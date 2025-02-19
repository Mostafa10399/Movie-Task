import Foundation
import Algorithms
import RxSwift

public final class MovieDetailsViewModel {
    
    // MARK: - Properties
    
    private let repository: MovieDetailsRepository
    private let id: Int
    private let responder: ToggledWatchlistResponder?
    
    private let movieDetailsSubject = BehaviorSubject<[MovieDetail]>(value: [])
    private let errorMessagesSubject = BehaviorSubject<ErrorMessage?>(value: nil)
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)

    public var list: Observable<[MovieDetail]> { return self.movieDetailsSubject.asObserver() }
    public var isLoading: Observable<Bool> { return self.isLoadingSubject.asObserver() }
    public var errorMessages: Observable<ErrorMessage?> { return self.errorMessagesSubject.asObserver() }
    public let errorPresentation = PublishSubject<ErrorPresentation?>()

    // State
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    
    public init(withId id: Int, repository: MovieDetailsRepository, responder: ToggledWatchlistResponder?) {
        self.repository = repository
        self.id = id
        self.responder = responder
        self.getMovieDetails()
        self.getSimilarMovies()
    }
    
    private func getMovieDetails() {
        isLoadingSubject.onNext(true)
        repository.getMovieDetails(withId: id)
            .compactMap(MovieDetailsPresentable.init)
            .asObservable()
            .subscribe { [weak self] in
                guard let strongSelf = self else { return }
                var value = (try? strongSelf.movieDetailsSubject.value()) ?? []
                value.append(MovieDetail.movie($0))
                strongSelf.movieDetailsSubject.onNext(value)
            } onError: { [weak self] in
                self?.errorMessagesSubject.onNext(ErrorMessage(error: $0))
            } onCompleted: { [weak self] in
                self?.isLoadingSubject.onNext(false)
            }.disposed(by: disposeBag)
    }
    
    private func getSimilarMovies() {
        repository.getSimilarMovies(to: id, page: nil)
            .map { Array($0.prefix(5)) }
            .map { $0.compactMap(MovieListPresentable.init) }
            .asObservable()
            .do(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                var value = (try? strongSelf.movieDetailsSubject.value()) ?? []
                value.append(MovieDetail.similar($0))
                strongSelf.movieDetailsSubject.onNext(value)
            }).flatMap {
                Observable.zip($0.map { self.repository.getCast(for: $0.id).asObservable() })
            }.map {
                $0.flatMap { $0 }
            }.map {
                Dictionary(grouping: $0, by: { (castMember: CrewMember) in
                    castMember.knownForDepartment ?? ""
                })
            }.subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                var value = (try? strongSelf.movieDetailsSubject.value()) ?? []
                if let actors = $0["Acting"]?.uniqued(on: { $0.name }).sorted(by: { $0.popularity ?? 0.0 > $1.popularity ?? 0.0 }).prefix(5) {
                        
                    value.append(MovieDetail.actors(actors.compactMap(CastMemberPresentable.init)))
                }
                if let directors = $0["Directing"]?.uniqued(on: { $0.name }).sorted(by: { $0.popularity ?? 0.0 > $1.popularity ?? 0.0 }).prefix(5) {
                    value.append(MovieDetail.directors(directors.compactMap(CastMemberPresentable.init)))
                }
                strongSelf.movieDetailsSubject.onNext(value)
            }).disposed(by: disposeBag)
    }

    // MARK: - Actions
    
    @objc
    public func toggleWatchlist() {
        repository.toggleWatchlist(for: id)
            .subscribe(onSuccess: { [weak self] watchlist in
                guard let strongSelf = self else { return }
                strongSelf.responder?.didToggleWatchlist(for: strongSelf.id)
                var value = (try? strongSelf.movieDetailsSubject.value()) ?? []
                guard let movieDetailsIndex = value.firstIndex(where: {
                    if case .movie = $0 { return true }
                    return false
                    
                }) else { return }
                
                if case .movie(var movie) = value.remove(at: movieDetailsIndex) {
                    movie.isInWatchlist.toggle()
                    value.append(.movie(movie))
                    strongSelf.movieDetailsSubject.onNext(value)
                }
            }).disposed(by: disposeBag)
    }

}