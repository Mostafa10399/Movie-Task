//
//  MovieListPresentable.swift
//  CoreKit
//
//  Created by Mostafa on 18/02/2025.
//

import Foundation

public struct MovieListPresentable: Hashable {
    public let thumbnail: String
    public let title: String
    public let overview: String
    public var isInWatchlist: Bool
    public let year: Int
    public let id: Int
    
    init(_ movieTuple: MovieWithWatchlist) {
        self.id = movieTuple.movie.id
        if let poster = movieTuple.movie.posterPath {
            self.thumbnail = "https://image.tmdb.org/t/p/w500" + poster
        } else {
            thumbnail = ""
        }
        self.title = movieTuple.movie.title ?? ""
        self.overview = movieTuple.movie.overview ?? ""
        self.isInWatchlist = movieTuple.isInWatchlist
        let formatter: DateFormatter = {
            $0.dateFormat = "yyyy-MM-dd"
            return $0
        }(DateFormatter())
        let calendar = Calendar.current
        if let date = movieTuple.movie.releaseDate, let releaseDate = formatter.date(from: date),
            let year = calendar.dateComponents([.year], from: releaseDate).year {
            self.year = year
        } else {
            self.year = -1
        }
    }
}
