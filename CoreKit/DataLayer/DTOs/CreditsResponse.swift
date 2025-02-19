//
//  CreditsResponse.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public struct CreditsResponse: Codable {
    let id: Int
    let crew: [CrewMember]
    let cast: [CastMember]
}
