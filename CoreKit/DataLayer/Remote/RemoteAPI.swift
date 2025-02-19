//
//  RemoteAPI.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation
import Alamofire

public protocol RemoteAPI {
    func request<T: Codable>(_ service: RemoteService) async throws -> T
}

extension RemoteAPI {
    public func request<T: Codable>(_ service: RemoteService) async throws -> T {
        try await AF
            .request(service)
            .validate(statusCode: 200..<400)
            .serializingDecodable(T.self)
            .executed(type: T.self)
    }
}
