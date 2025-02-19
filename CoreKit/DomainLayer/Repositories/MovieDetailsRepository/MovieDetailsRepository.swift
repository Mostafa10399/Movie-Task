//
//  MovieDetailsRepository.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public protocol MovieDetailsRepository {
    func getMovieDetails(withId id: Int) async throws -> MovieWithWatchlist
    func getSimilarMovies(to id: Int, page: Int?) async throws -> [MovieWithWatchlist]
    func getCast(for id: Int) async throws -> [CrewMember]
    func toggleWatchlist(for id: Int) async throws -> Bool
}

