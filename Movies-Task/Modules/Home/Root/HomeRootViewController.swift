import UIKit
import AppUIKit
import CoreKit
import RxSwift

public class HomeRootViewController: NiblessViewController {

    // MARK: - Properties
    
    private let viewModel: HomeRootViewModel
    private let customView: HomeRootView
    
    // Childs
    private let popularMoviesViewController: PopularMoviesViewController
    
    // State
    private let disposeBag = DisposeBag()

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
        title = R.string.localizable.moviesApp()
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
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else { return }
                strongSelf.present(errorMessage: errorMessage,
                                   withPresentationState: strongSelf.viewModel.errorPresentation)
            })
            .disposed(by: disposeBag)
    }
}
