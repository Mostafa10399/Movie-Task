//
//  CrewMember.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public struct CrewMember: Codable, Hashable, Equatable {
    let id: Int
    let adult: Bool?
    let gender: Int?
    let knownForDepartment, name, originalName: String?
    let popularity: Double?
    let profilePath, creditId, department, job: String?
    
    public static func ==(lhs: CrewMember, rhs: CrewMember) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case creditId = "credit_id"
        case department, job
    }
}
