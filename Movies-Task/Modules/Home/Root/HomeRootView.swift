//
//  HomeRootView.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import UIKit
import SnapKit
import AppUIKit

class HomeRootView: NiblessView {

    // MARK: - Properties

    lazy private(set) var searchController = UISearchController(searchResultsController: searchResultsController).with {
        $0.searchBar.placeholder = "write the name of the movie you want to search on"
        $0.searchResultsUpdater = searchResultsController as? UISearchResultsUpdating
    }
    
    private let searchResultsController: UIViewController?
        
    // MARK: - Methods
    init(searchResultsController: UIViewController?) {
        self.searchResultsController = searchResultsController
        super.init(frame: .zero)
        constructHierarchy()
        activateConstraints()
        styleView()
    }

    private func constructHierarchy() {
        
    }

    private func activateConstraints() {

    }

    private func styleView() {
        backgroundColor = .white
    }
}
