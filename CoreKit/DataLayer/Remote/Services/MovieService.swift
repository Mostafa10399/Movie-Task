//
//  MovieService.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation
import Alamofire

public enum MovieService {
    case popular(auth: String, page: Int? = nil, region: String? = nil, language: String? = nil)
    case movie(auth: String, id: Int, language: String? = nil)
    case similar(auth: String, id: Int, page: Int? = nil, language: String? = nil)
    case credits(auth: String, id: Int, language: String? = nil)
}

extension MovieService: MoviesDBService {
    public var mainRoute: String { return "movie/" }

    public var requestConfiguration: RequestConfiguration {
        switch self {
        case let .popular(auth, page, region, language):
            var parameters: [String: Any] = ["api_key": auth]
            if let page = page {
                parameters["page"] = page
            }
            if let region = region {
                parameters["region"] = region
            }
            if let language = language {
                parameters["language"] = language
            }
            return RequestConfiguration(
                method: .get,
                path: mainRoute.appending("popular"),
                parameters: parameters,
                encoding: URLEncoding.default,
                language: language
            )
        case let .movie(auth, id, language):
            var parameters: [String: Any] = ["api_key": auth]
            if let language = language {
                parameters["language"] = language
            }
            return RequestConfiguration(
                method: .get,
                path: mainRoute.appending("\(id)"),
                parameters: parameters,
                encoding: URLEncoding.default,
                language: language
            )
        case let .similar(auth, id, page, language):
            var parameters: [String: Any] = ["api_key": auth]
            if let page = page {
                parameters["page"] = page
            }
            if let language = language {
                parameters["language"] = language
            }
            return RequestConfiguration(
                method: .get,
                path: mainRoute.appending("\(id)/").appending("similar"),
                parameters: parameters,
                encoding: URLEncoding.default,
                language: language
            )
        case let .credits(auth, id, language):
            var parameters: [String: Any] = ["api_key": auth]
            if let language = language {
                parameters["language"] = language
            }
            return RequestConfiguration(
                method: .get,
                path: mainRoute.appending("\(id)/").appending("credits"),
                parameters: parameters,
                encoding: URLEncoding.default,
                language: language
            )
        }
    }
}
