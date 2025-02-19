//
//  DataTaskExecuted.swift
//  Movies-Task
//
//  Created by Mostafa on 18/02/2025.
//


import Foundation
import Alamofire

extension DataTask {
    func executed<T: Codable>(type: T.Type) async throws -> T {
        do {
            let response = await self.result
            switch response {
            case let .success(data):
                return data as! T
            case let .failure(error):
                throw ErrorMessage(error: error)
            }
        } catch {
            throw ErrorMessage(error: error)
        }
    }
}
