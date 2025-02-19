//
//  MovieAPI.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public protocol MovieAPI: RemoteAPI {
    func getPopularMovies(
        auth: String,
        page: Int?,
        region: String?,
        language: String?
    ) async throws -> PaginationResponse<Movie>
    
    func getMovieDetails(
        auth: String,
        id: Int,
        language: String?
    ) async throws -> Movie
    
    func getSimilarMovies(
        auth: String,
        id: Int,
        page: Int?,
        language: String?
    ) async throws -> PaginationResponse<Movie>
    
    func getCredits(
        auth: String,
        id: Int,
        language: String?
    ) async throws -> CreditsResponse
}

