import UIKit
import SnapKit
import AppUIKit

class HomeRootView: NiblessView {

    // MARK: - Properties

    lazy private(set) var searchController = UISearchController(searchResultsController: searchResultsController).with {
        $0.searchBar.placeholder = "Type name of the movie"
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