//
//  Movie.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public struct Movie: Codable {
    let id: Int
    let overview, title: String?
    let posterPath: String?
    let releaseDate: String?
    let revenue: Double?
    let status, tagline: String?
}
