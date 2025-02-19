//
//  XCConfigUserSessionDataStore.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

final public class XCConfigUserSessionDataStore: UserSessionDataStore {
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    public init() {}
    
    public func getSession() async -> UserSession? {
        return Bundle(for: XCConfigUserSessionDataStore.self).infoDictionary?["Movies db app id"] as? String
    }
}

