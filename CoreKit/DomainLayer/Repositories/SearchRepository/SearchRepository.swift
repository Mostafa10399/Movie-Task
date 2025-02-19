//
//  SearchRepository.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public protocol SearchRepository {
    func search(query: String, page: Int) async throws -> [MovieWithWatchlist]
}
