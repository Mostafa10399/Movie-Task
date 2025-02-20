//
//  SearchResultsViewController.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//

import Foundation
import AppUIKit
import UIKit
import CoreKit
import Combine

public class SearchResultsViewController: NiblessViewController {

    // MARK: - Properties
    
    private let viewModel: SearchResultsViewModel
    private let customView: SearchResultsView
    
    // DataSource & DataSourceSnapShot TypeAlies
    typealias DataSource = UITableViewDiffableDataSource<String, MovieListPresentable>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, MovieListPresentable>
    
    // DataSource & DataSourceSnapShot
    private lazy var datasource = makeDataSource()
    private var datasourceSnapShot = DataSourceSnapshot()
    
    // State
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Methods
    init(view: SearchResultsView, viewModel: SearchResultsViewModel) {
        self.viewModel = viewModel
        self.customView = view
        super.init()
    }

    override public func loadView() {
        view = customView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessages()
        bindViewModel()
        
        customView.tableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                self?.viewModel.selectItemSubject.send(indexPath.row)
            }
            .store(in: &cancellables)
        
        customView.tableView.willDisplayCellPublisher
            .sink { [weak self] cell, indexPath in
                self?.viewModel.currentDisplayedItemSubject.send(indexPath.row)
            }
            .store(in: &cancellables)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func bindViewModel() {
        viewModel.list
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let strongSelf = self else { return }
                strongSelf.updateSnapshot(with: movies)
            }
            .store(in: &cancellables)
    }
    
    private func observeErrorMessages() {
        viewModel.errorMessagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let strongSelf = self else { return }
                strongSelf.present(
                    errorMessage: errorMessage,
                    withPresentationState: strongSelf.viewModel.errorPresentation
                )
            }
            .store(in: &cancellables)
    }
    
    private func makeDataSource() -> DataSource {
        return DataSource(tableView: customView.tableView) { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return UITableViewCell() }
            cell.configure(with: movie)
            return cell
        }
    }
    
    private func updateSnapshot(with movies: [MovieListPresentable]) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections(["Search results"])
        snapshot.appendItems(movies, toSection: "Search results")
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchTextSubject.send(searchController.searchBar.text)
    }
}
