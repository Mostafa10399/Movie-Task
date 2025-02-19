//
//  UserSessionDataStore.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public typealias UserSession = String

public protocol UserSessionDataStore {
    func getSession() async -> UserSession?
}
