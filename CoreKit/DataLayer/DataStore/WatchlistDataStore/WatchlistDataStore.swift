//
//  WatchlistDataStore.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public protocol WatchlistDataStore {
    func getWatchlist() async throws -> [Int]
    func isMovieInWatchlist(id: Int) async throws -> Bool
    func addToWatchlist(id: Int) async throws
    func removeFromWatchlist(id: Int) async throws
}
