//
//  MovieDetail.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public enum MovieDetail: Hashable {
    public static func == (lhs: MovieDetail, rhs: MovieDetail) -> Bool {
        return lhs.index == rhs.index
    }
    
    case movie(MovieDetailsPresentable)
    case similar([MovieListPresentable])
    case directors([CastMemberPresentable])
    case actors([CastMemberPresentable])
    
    public var index: Int {
        switch self {
        case .movie: return 0
        case .similar: return 1
        case .directors: return 2
        case .actors: return 3
        }
    }
    
    public var title: String {
        switch self {
        case .movie: return ""
        case .similar: return "Similar movies"
        case .directors: return "Directors"
        case .actors: return "Actors"
        }
    }
}
