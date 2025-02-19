import Foundation
import RxSwift

public final class PopularMoviesViewModel {
    
    // MARK: - Properties
    
    private let repository: MovieRepository
    private let navigator: MovieDetailsNavigator
    
    private let popularMoviesSubject = BehaviorSubject<[Int: [MovieListPresentable]]>(value: [:])
    private let errorMessagesSubject = BehaviorSubject<ErrorMessage?>(value: nil)
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)

    public var list: Observable<[Int: [MovieListPresentable]]> { return self.popularMoviesSubject.asObserver() }
    public var isLoading: Observable<Bool> { return self.isLoadingSubject.asObserver() }
    public var errorMessages: Observable<ErrorMessage?> { return self.errorMessagesSubject.asObserver() }
    public let errorPresentation = PublishSubject<ErrorPresentation?>()
    public let selectItemSubject = PublishSubject<Int>()

    // State
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    
    public init(repository: MovieRepository, navigator: MovieDetailsNavigator) {
        self.repository = repository
        self.navigator = navigator
        self.getData()
        self.subscribeToSelectItem()
    }
    
    
    private func getData() {
        isLoadingSubject.onNext(true)
        repository.getPopularMovies(page: 1)
            .compactMap { $0.compactMap(MovieListPresentable.init) }
            .compactMap { Dictionary(grouping: $0, by: { $0.year })}
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.popularMoviesSubject.onNext($0)
            }, onError: { [weak self] in
                self?.errorMessagesSubject.onNext(ErrorMessage(error: $0))
            }, onCompleted: { [weak self] in
                self?.isLoadingSubject.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    private func subscribeToSelectItem() {
        selectItemSubject
            .subscribe(onNext: { [weak self] in
                self?.navigator.navigateToMovieDetails(with: $0, responder: self)
            }).disposed(by: disposeBag)
    }

}

extension PopularMoviesViewModel: ToggledWatchlistResponder {
    public func didToggleWatchlist(for id: Int) {
        getData()
    }
}
