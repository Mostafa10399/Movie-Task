//
//  CastMember.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public struct CastMember: Codable, Hashable {
    let adult: Bool?
    let id: Int
    let gender: Int?
    let knownForDepartment, name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castId: Int?
    let character, creditId: String?
    let order: Int?
}
