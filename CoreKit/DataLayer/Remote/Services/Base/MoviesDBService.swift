//
//  MoviesDBService.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public protocol MoviesDBService: RemoteService {
    var mainRoute: String { get }
}

extension MoviesDBService {
    public var baseURL: String {
        return (Bundle(for: DefaultMovieDetailsRepositoryImpelementation.self)
            .infoDictionary?["Movies db api url"] as? String)?
            .replacingOccurrences(of: "\\", with: "") ?? ""
    }
}
