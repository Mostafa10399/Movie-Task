//
//  MovieDetailsViewController.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//

import Combine
import UIKit
import CombineCocoa
import AppUIKit
import CoreKit

public class MovieDetailsViewController: NiblessViewController {

    // MARK: - Properties
    
    private let viewModel: MovieDetailsViewModel
    private let customView: MovieDetailsView
    
    // DataSource & DataSourceSnapShot TypeAlias
    typealias DataSource = UITableViewDiffableDataSource<String, MovieDetail>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, MovieDetail>
        
    // DataSource & DataSourceSnapShot
    private lazy var datasource = makeDataSource()
    private var datasourceSnapShot = DataSourceSnapshot()
    
    // State
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    init(view: MovieDetailsView, viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        self.customView = view
        super.init()
    }

    override public func loadView() {
        view = customView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Details"
        observeErrorMessages()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.list
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieDetails in
                self?.updateSnapshot(with: movieDetails)
            }
            .store(in: &cancellables)
    }
    
    private func updateSnapshot(with movieDetails: [MovieDetail]) {
        var snapshot = DataSourceSnapshot()
        let sortedDetails = movieDetails.sorted(by: { $0.index < $1.index })
        for detail in sortedDetails {
            snapshot.appendSections([detail.title])
            snapshot.appendItems([detail], toSection: detail.title)
        }
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    private func observeErrorMessages() {
        viewModel
            .errorMessagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.present(
                    errorMessage: $0,
                    withPresentationState: self?.viewModel.errorPresentation
                )
            }
            .store(in: &cancellables)
    }
}

extension MovieDetailsViewController {
    // MARK: - Data Source
    private func makeDataSource() -> DataSource {
        return DataSource(tableView: customView.tableView) { tableView, indexPath, element in
            switch element {
            case .movie(let movie):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsCell", for: indexPath) as? MovieDetailsCell else {
                    return UITableViewCell()
                }
                cell.configure(with: movie)
                cell.watchlistButton.addTarget(self.viewModel, action: #selector(MovieDetailsViewModel.toggleWatchlist), for: .touchUpInside)
                return cell
            case .similar(let movies):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalMoviesListCell", for: indexPath) as? HorizontalMoviesListCell else {
                    return UITableViewCell()
                }
                cell.configure(with: movies)
                return cell
            case .directors(let castMembers), .actors(let castMembers):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalCastMembersListCell", for: indexPath) as? HorizontalCastMembersListCell else {
                    return UITableViewCell()
                }
                cell.configure(with: castMembers)
                return cell
            }
        }
    }
}
