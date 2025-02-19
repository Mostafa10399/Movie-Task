//
//  DefaultSearchRepositoryImpel.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//
import Foundation

final public class DefaultSearchRepositoryImpel: SearchRepository {
    
    // MARK: - Properties
    
    private let remoteAPI: SearchAPI
    private let userSessionDataStore: UserSessionDataStore
    private let watchlistDataStore: WatchlistDataStore
    
    // MARK: - Methods
    
    public init(remoteAPI: SearchAPI, userSessionDataStore: UserSessionDataStore, watchlistDataStore: WatchlistDataStore) {
        self.remoteAPI = remoteAPI
        self.userSessionDataStore = userSessionDataStore
        self.watchlistDataStore = watchlistDataStore
    }
    
    public func search(query: String, page: Int) async throws -> [MovieWithWatchlist] {
        guard let session = await userSessionDataStore.getSession() else {
            throw ErrorMessage(
                error: NSError(
                    domain: "SessionError",
                    code: 401,
                    userInfo: [NSLocalizedDescriptionKey: "No user session found"]
                )
            )
        }
        let searchResults = try await remoteAPI.searchMovie(
            auth: session,
            query: query,
            page: page,
            language: nil,
            includeAdult: nil,
            region: nil,
            year: nil,
            primaryReleaseYear: nil
        )
        guard let movies = searchResults.results, !movies.isEmpty else { return [] }
        return try await movies.concurrentMap { movie in
            let isInWatchlist = try await self.watchlistDataStore.isMovieInWatchlist(id: movie.id)
            return MovieWithWatchlist(movie: movie, isInWatchlist: isInWatchlist)
        }
    }
}

