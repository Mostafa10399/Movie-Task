//
//  MovieDetailsCell.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import UIKit
import CoreKit

final public class MovieDetailsCell: UITableViewCell {

    @IBOutlet private(set) public weak var thumbnailImage: UIImageView!
    @IBOutlet private(set) public weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet private(set) public weak var overviewLabel: UILabel! {
        didSet {
            overviewLabel.numberOfLines = 0
        }
    }
    @IBOutlet private(set) public weak var revenueLabel: UILabel!
    @IBOutlet private(set) public weak var releaseDateLabel: UILabel!
    @IBOutlet private(set) public weak var watchlistButton: UIButton! {
        didSet {
            watchlistButton.setTitle("", for: .normal)
        }
    }
    
    public func configure(with item: MovieDetailsPresentable) {
        thumbnailImage.kf.setImage(with: item.thumbnail.isEmpty ? nil : URL(string: item.thumbnail), placeholder: UIImage(resource: .moviePoster))
        titleLabel.text = item.title
        overviewLabel.text = item.overview
        revenueLabel.text = item.rate
        releaseDateLabel.text = item.releaseDate
        watchlistButton.setImage(item.isInWatchlist ? UIImage(resource: .bookmarkActive) : UIImage(resource: .bookmark), for: .normal)
    }

}
