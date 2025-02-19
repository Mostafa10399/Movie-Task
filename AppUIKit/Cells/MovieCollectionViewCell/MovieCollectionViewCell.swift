//
//  ImageAndLabelCollectionViewCell.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import UIKit
import CoreKit
import Kingfisher

final public class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet private(set) public weak var thumbnailImage: UIImageView!
    @IBOutlet private(set) public weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }

    public func configure(with item: MovieListPresentable) {
        thumbnailImage.kf.setImage(with: item.thumbnail.isEmpty ? nil : URL(string: item.thumbnail), placeholder: UIImage(resource: .moviePoster))
        titleLabel.text = item.title
    }
    
    public func configure(with item: CastMemberPresentable) {
        thumbnailImage.kf.setImage(with: item.profile.isEmpty ? nil : URL(string: item.profile), placeholder: UIImage(resource: .moviePoster))
        titleLabel.text = item.name
    }
}
