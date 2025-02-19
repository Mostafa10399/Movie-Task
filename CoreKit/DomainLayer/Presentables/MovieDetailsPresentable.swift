//
//  MovieDetailsPresentable.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public struct MovieDetailsPresentable {
    public let thumbnail: String
    public let title: String
    public let overview: String
    public var isInWatchlist: Bool
    public let rate: String
    public let releaseDate: String
    
    init(_ movieTuple: MovieWithWatchlist) {
        if let poster = movieTuple.movie.posterPath {
            self.thumbnail = "https://image.tmdb.org/t/p/w500" + poster
        } else {
            thumbnail = ""
        }
        self.title = movieTuple.movie.title ?? ""
        self.overview = movieTuple.movie.overview ?? ""
        self.isInWatchlist = movieTuple.isInWatchlist
        self.releaseDate = movieTuple.movie.releaseDate ?? "Unkown"
        self.rate = "\(movieTuple.movie.voteAverage ?? 0)"
    }
}
