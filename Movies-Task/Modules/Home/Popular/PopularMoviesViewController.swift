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
    // DataSource & DataSourceSnapShot TypeAlies
    typealias DataSource = UITableViewDiffableDataSource<Int, MovieListPresentable>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, MovieListPresentable>
        
    
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
                guard let strongSelf = self else { return }
                strongSelf.updateSnapshot(with: movieSections)
            }
            .store(in: &cancellables)
    }
    
    private func observeErrorMessages() {
        viewModel
            .errorMessagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.present(
                    errorMessage: $0,
                    withPresentationState: strongSelf.viewModel.errorPresentation
                )
            }
            .store(in: &cancellables)
            
    }
}

extension PopularMoviesViewController {
    // MARK: - Data Source
    private func makeDataSource() -> DataSource {
        return DataSource(tableView: customView.tableView) { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return UITableViewCell() }
            cell.configure(with: movie)
            return cell
        }
    }
    
    private func updateSnapshot(with sections: [Int: [MovieListPresentable]]) {
        var snapshot = DataSourceSnapshot()
        let sortedSections = sections.keys.sorted(by: >)
        for section in sortedSections {
            if let items = sections[section] {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }
        }
        datasource.apply(snapshot, animatingDifferences: true)
    }
}
