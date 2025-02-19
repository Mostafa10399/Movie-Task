//
//  MDBMovieAPI.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

final public class MDBMovieAPI: MovieAPI {
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    public init() { }
    
    public func getPopularMovies(
        auth: String,
        page: Int?,
        region: String?,
        language: String?
    ) async throws -> PaginationResponse<Movie> {
        try await request(
            MovieService.popular(
                auth: auth,
                page: page,
                region: region,
                language: language
            )
        )
    }
    
    public func getMovieDetails(
        auth: String,
        id: Int,
        language: String?
    ) async throws -> Movie {
        try await request(
            MovieService.movie(
                auth: auth,
                id: id,
                language: language
            )
        )
    }
    
    public func getSimilarMovies(
        auth: String,
        id: Int,
        page: Int?,
        language: String?
    ) async throws -> PaginationResponse<Movie> {
        try await request(
            MovieService.similar(
                auth: auth,
                id: id,
                page: page,
                language: language
            )
        )
    }
    
    public func getCredits(
        auth: String,
        id: Int,
        language: String?
    ) async throws -> CreditsResponse {
        try await request(
            MovieService.credits(
                auth: auth,
                id: id,
                language: language
            )
        )
    }
}
