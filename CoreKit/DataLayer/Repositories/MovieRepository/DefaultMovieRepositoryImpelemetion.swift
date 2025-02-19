//
//  DefaultMovieRepositoryImpel.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

final public class DefaultMovieRepositoryImpelemetion: MovieRepository {
    
    // MARK: - Properties
    
    private let remoteAPI: MovieAPI
    private let userSessionDataStore: UserSessionDataStore
    private let watchlistDataStore: WatchlistDataStore
    
    // MARK: - Methods
    
    public init(
        remoteAPI: MovieAPI,
        userSessionDataStore: UserSessionDataStore,
        watchlistDataStore: WatchlistDataStore
    ) {
        self.remoteAPI = remoteAPI
        self.userSessionDataStore = userSessionDataStore
        self.watchlistDataStore = watchlistDataStore
    }
    
    public func getPopularMovies(page: Int) async throws -> [MovieWithWatchlist] {
        guard let session = await userSessionDataStore.getSession() else {
            throw ErrorMessage(
                error: NSError(
                    domain: "SessionError",
                    code: 401,
                    userInfo: [NSLocalizedDescriptionKey: "No user session found"]
                )
            )
        }
        let movieList = try await remoteAPI.getPopularMovies(auth: session, page: page, region: nil, language: nil).results ?? []
        return try await movieList.concurrentMap { movie in
            let isInWatchlist = try await self.watchlistDataStore.isMovieInWatchlist(id: movie.id)
            return MovieWithWatchlist(movie: movie, isInWatchlist: isInWatchlist)
        }
    }
}
