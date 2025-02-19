//
//  MDBSearchAPI.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

final public class MDBSearchAPI: SearchAPI {
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    public init() {}
    
    public func searchMovie(
        auth: String,
        query: String,
        page: Int?,
        language: String?,
        includeAdult: Bool?,
        region: String?,
        year: Int?,
        primaryReleaseYear: Int?
    ) async throws -> PaginationResponse<Movie> {
        try await request(
            SearchService.movies(
                auth: auth,
                query: query,
                page: page,
                language: language,
                includeAdult: includeAdult,
                region: region,
                year: year,
                primaryReleaseYear: primaryReleaseYear
            )
        )
    }

}
