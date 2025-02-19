//
//  RequestConfiguration.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation
import Alamofire

public struct RequestConfiguration {

    // MARK: - Properties
    let path: String
    let method: HTTPMethod
    let headers: [HTTPHeader]?
    let parameters: Parameters?
    let encoding: ParameterEncoding

    // MARK: - Methods
    internal init(method: HTTPMethod = .get,
                  path: String,
                  headers: [HTTPHeader]? = nil,
                  parameters: Parameters? = nil,
                  encoding: ParameterEncoding = URLEncoding.default,
                  language: String? = nil) {
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.encoding = encoding
    }
}
