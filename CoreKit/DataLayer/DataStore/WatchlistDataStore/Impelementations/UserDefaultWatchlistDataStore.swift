//
//  UserDefaultWatchlistDataStore.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

final public class UserDefaultWatchlistDataStore: WatchlistDataStore {
    
    private let userDefaults = UserDefaults.standard
    private let watchlistKey = "UserDefaultWatchlistDataStore"
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Methods
    
    public func getWatchlist() async throws -> [Int] {
        return userDefaults.array(forKey: watchlistKey) as? [Int] ?? []
    }
    
    public func isMovieInWatchlist(id: Int) async throws -> Bool {
        let watchlist = try await getWatchlist()
        return watchlist.contains(id)
    }
    
    public func addToWatchlist(id: Int) async throws {
        var watchlist = try await getWatchlist()
        if !watchlist.contains(id) {
            watchlist.append(id)
            try await updateWatchlistFile(with: watchlist)
        }
    }
    
    public func removeFromWatchlist(id: Int) async throws {
        var watchlist = try await getWatchlist()
        watchlist.removeAll { $0 == id }
        try await updateWatchlistFile(with: watchlist)
    }
    
    // MARK: - Private Helpers
    
    private func updateWatchlistFile(with ids: [Int]) async throws {
        userDefaults.set(ids, forKey: watchlistKey)
    }
}
