//
//  HomeNavigationControler.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//

import UIKit
import CoreKit
import AppUIKit
import Combine

final class HomeViewController: NiblessNavigationController {
    
    // MARK: - Properties
    
    private let viewModel: HomeNavigationViewModel
    private let rootViewController: HomeRootViewController
    private let makeMovieDetailsViewController: ((Int, ToggledWatchlistResponder) -> MovieDetailsViewController)
    private var cancelable: Set<AnyCancellable> = []
    
    // MARK: - Methods
    
    init(
        viewModel: HomeNavigationViewModel,
        rootViewController: HomeRootViewController,
        movieDetailsViewControllerFactory: @escaping (Int, ToggledWatchlistResponder) -> MovieDetailsViewController
    ) {
        self.viewModel = viewModel
        self.rootViewController = rootViewController
        self.makeMovieDetailsViewController = movieDetailsViewControllerFactory
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
        viewControllers = [rootViewController]
    }
    
    private func observeViewModel() {
        let publisher = viewModel.$view.eraseToAnyPublisher()
        subscriber(to: publisher)
    }
    
    private func subscriber(to publisher: AnyPublisher<HomeView, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] view in
                guard let strongSelf = self else {return}
                strongSelf.present(view)
            }
            .store(in: &cancelable)
    }
    
    private func present(_ view: HomeView) {
        switch view {
        case .root:
            presentHomeRootView()
        case let .details(id, responder):
            presentMovieDetails(using: id, responder: responder)
        }
    }
    
    private func presentHomeRootView() {
        popToRootViewController(animated: false)
    }
    
    private func presentMovieDetails(using id: Int, responder: ToggledWatchlistResponder) {
        pushViewController(makeMovieDetailsViewController(id, responder), animated: true)
    }
}
