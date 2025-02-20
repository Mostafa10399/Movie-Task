//
//  HorizontalCastMembersListCell.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import UIKit
import CoreKit

final public class HorizontalCastMembersListCell: UITableViewCell {
    
    typealias DataSource = UICollectionViewDiffableDataSource<BasicSection, CastMemberPresentable>
    typealias DataSourceSnapShot = NSDiffableDataSourceSnapshot<BasicSection, CastMemberPresentable>
    private lazy var datasource = configureDataSource()
    private var datasourceSnapShot = DataSourceSnapShot()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        let space = 10 as CGFloat
        flowLayout.itemSize = CGSize(width: 120, height: 220)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.setCollectionViewLayout(flowLayout, animated: false)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: Bundle(for: MovieCollectionViewCell.self)), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        }
    }
    
    private var items = [CastMemberPresentable]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    public func configure(with items: [CastMemberPresentable]) {
        self.items = items
        makeDataSourceSnapShot(data: items)
        
    }
}

extension HorizontalCastMembersListCell {
    
    private func configureDataSource() -> DataSource {
        DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collection, indexPath, itemIdentifier -> UICollectionViewCell in
                guard let strongSelf = self, let cell = collection.dequeueReusableCell(
                    withReuseIdentifier: "MovieCollectionViewCell",
                    for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: strongSelf.items[indexPath.item])
                return cell
            })
    }
    
    // DataSourceSnapShot
    private func makeDataSourceSnapShot(data: [CastMemberPresentable]) {
        datasourceSnapShot = DataSourceSnapShot()
        datasourceSnapShot.appendSections([BasicSection.main])
        datasourceSnapShot.appendItems(data)
        datasource.apply(datasourceSnapShot, animatingDifferences: false)
    }
    
}
