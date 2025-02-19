//
//  SearchAPI.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation


public protocol SearchAPI: RemoteAPI {
    func searchMovie(
        auth: String,
        query: String,
        page: Int?,
        language: String?,
        includeAdult: Bool?,
        region: String?,
        year: Int?,
        primaryReleaseYear: Int?
    ) async throws -> PaginationResponse<Movie>
}
