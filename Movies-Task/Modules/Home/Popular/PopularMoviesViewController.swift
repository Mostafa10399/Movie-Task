//
//  PopularMoviesViewController.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//

import UIKit
import AppUIKit
import CoreKit
import Combine
import CombineCocoa

public class PopularMoviesViewController: NiblessViewController {

    // MARK: - Properties
    
    private let viewModel: PopularMoviesViewModel
    private let customView: PopularMoviesView
    // DataSource & DataSourceSnapShot TypeAlias
    var list: [Int: [MovieListPresentable]] = [:]
    typealias DataSource = CustomDataSource
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, MovieListPresentable>
        
    // DataSource & DataSourceSnapShot
    private lazy var datasource = makeDataSource()
    private var datasourceSnapShot = DataSourceSnapshot()

    // State
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Methods
    init(view: PopularMoviesView, viewModel: PopularMoviesViewModel) {
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
        customView.tableView.didSelectRowPublisher.receive(subscriber: viewModel.selectedItemSubscriber)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func bindViewModel() {
        viewModel.list
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieSections in
                guard let self = self else { return }
                self.list = movieSections
                self.updateSnapshot(with: movieSections)
            }
            .store(in: &cancellables)
    }
    
    private func observeErrorMessages() {
        viewModel.errorMessagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.present(
                    errorMessage: $0,
                    withPresentationState: self.viewModel.errorPresentation
                )
            }
            .store(in: &cancellables)
    }
}

// MARK: - Data Source Management
extension PopularMoviesViewController {
    private func makeDataSource() -> CustomDataSource {
        return CustomDataSource(tableView: customView.tableView) { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
                return UITableViewCell()
            }
            cell.configure(with: movie)
            return cell
        }
    }
    
    private func updateSnapshot(with sections: [Int: [MovieListPresentable]]) {
        var snapshot = DataSourceSnapshot()
        let sortedSections = sections.keys.sorted(by: >)
        for section in sortedSections {
            let sectionTitle = "Year \(section)"
            if let items = sections[section], !items.isEmpty {
                snapshot.appendSections([sectionTitle])
                snapshot.appendItems(items, toSection: sectionTitle)
            }
        }
        
        print("Snapshot Sections: \(snapshot.sectionIdentifiers)")
        print("Snapshot Items: \(snapshot.itemIdentifiers)")
        
        datasource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Custom Data Source
class CustomDataSource: UITableViewDiffableDataSource<String, MovieListPresentable> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[safe: section]
    }
}

