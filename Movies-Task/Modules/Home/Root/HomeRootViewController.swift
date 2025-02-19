//
//  HomeRootViewController.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import UIKit
import AppUIKit
import CoreKit
import Combine

public class HomeRootViewController: NiblessViewController {

    // MARK: - Properties
    
    private let viewModel: HomeRootViewModel
    private let customView: HomeRootView
    
    // Childs
    private let popularMoviesViewController: PopularMoviesViewController
    
    // State
    private var cancellable: Set<AnyCancellable> = []

    // MARK: - Methods
    init(view: HomeRootView, viewModel: HomeRootViewModel, popularMoviesViewController: PopularMoviesViewController) {
        self.viewModel = viewModel
        self.customView = view
        self.popularMoviesViewController = popularMoviesViewController
        super.init()
    }

    override public func loadView() {
        view = customView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessages()
        title = "Movies App"
        navigationItem.searchController = customView.searchController
        addChild(popularMoviesViewController)
        popularMoviesViewController.didMove(toParent: self)
        view.addSubview(popularMoviesViewController.view)
        view.bringSubviewToFront(popularMoviesViewController.view)
        popularMoviesViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            .store(in: &cancellable)
            
    }
}
