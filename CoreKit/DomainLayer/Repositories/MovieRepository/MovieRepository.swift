//
//  MovieRepository.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public protocol MovieRepository {
    func getPopularMovies(page: Int) async throws -> [MovieWithWatchlist]
}
