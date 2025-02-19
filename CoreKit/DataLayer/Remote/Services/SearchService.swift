//
//  SearchService.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation
import Alamofire

public enum SearchService {
    case movies(
        auth: String,
        query: String,
        page: Int? = nil,
        language: String? = nil,
        includeAdult: Bool? = nil,
        region: String? = nil,
        year: Int? = nil,
        primaryReleaseYear: Int? = nil
    )
}

extension SearchService: MoviesDBService {
    public var mainRoute: String { return "search/" }

    public var requestConfiguration: RequestConfiguration {
        switch self {
        case let .movies(
            auth,
            query,
            page,
            language,
            includeAdult,
            region,
            year,
            primaryReleaseYear
        ):
            let rawParameters: [String: Any?] = [
                           "api_key": auth,
                           "language": language,
                           "query": query,
                           "page": page,
                           "include_adult": includeAdult,
                           "region": region,
                           "year": year,
                           "primary_release_year": primaryReleaseYear
                       ]
            let parameters: [String: Any] = rawParameters.compactMapValues { $0 }
            return RequestConfiguration(
                method: .get,
                path: mainRoute.appending("movie"),
                parameters: parameters,
                encoding: URLEncoding.default            )
        }
    }
}
