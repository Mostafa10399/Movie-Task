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
}
