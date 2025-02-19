//
//  SearchResultsViewModel.swift
//  CoreKit
//
//  Created by Amr Salman on 26/04/2022.
//

import Foundation
import RxSwift

public final class SearchResultsViewModel {
    
    // MARK: - Properties
    
    private let repository: SearchRepository
    private var nextPage = 1
    private var canLoadMore = true
    private let navigator: MovieDetailsNavigator
    
    private let searchResultsSubject = BehaviorSubject<[MovieListPresentable]>(value: [])
    private let errorMessagesSubject = BehaviorSubject<ErrorMessage?>(value: nil)
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)

    public var list: Observable<[MovieListPresentable]> { return self.searchResultsSubject.asObserver() }
    public var isLoading: Observable<Bool> { return self.isLoadingSubject.asObserver() }
    public var errorMessages: Observable<ErrorMessage?> { return self.errorMessagesSubject.asObserver() }
    public let errorPresentation = PublishSubject<ErrorPresentation?>()
    public let searchTextSubject = BehaviorSubject<String?>(value: nil)
    public let currentDisplayedItemSubject = PublishSubject<Int>()
    public let selectItemSubject = PublishSubject<Int>()

    // State
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    
    public init(repository: SearchRepository, navigator: MovieDetailsNavigator) {
        self.repository = repository
        self.navigator = navigator
        self.subscribeToSearch()
        self.subscribeToLoadMore()
        self.subscribeToSelectItem()
    }
    
    private func loadMovies(with keyword: String) {
        self.repository.search(query: keyword, page: self.nextPage)
            .map { $0.map(MovieListPresentable.init) }
            .asObservable()
            .catch { error in
                guard let error = error as? RxSwift.RxError, case RxSwift.RxError.noElements = error else { return Observable.error(error) }
                return Observable.empty()
            }.subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                let newValue = [try? strongSelf.searchResultsSubject.value(), $0].compactMap { $0 }.flatMap { $0 }
                strongSelf.searchResultsSubject.onNext(newValue)
                strongSelf.nextPage += 1
                strongSelf.canLoadMore = !$0.isEmpty
            }, onError: { [weak self] in
                print($0)
                self?.errorMessagesSubject.onNext(ErrorMessage(error: $0))
            }, onCompleted: { [weak self] in
                self?.isLoadingSubject.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    
    private func subscribeToSearch() {
        searchTextSubject
            .compactMap { $0 }
            .debounce(RxTimeInterval.milliseconds(500), scheduler: SerialDispatchQueueScheduler.init(qos: .userInitiated))
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.searchResultsSubject.onNext([])
                strongSelf.nextPage = 1
                strongSelf.canLoadMore = true
                if !$0.isEmpty {
                    strongSelf.loadMovies(with: $0)
                }
            }).disposed(by: disposeBag)
    }
    
    private func subscribeToLoadMore() {
        currentDisplayedItemSubject
            .filter { $0 > 0 }
            .filter { ((try? self.searchResultsSubject.value())?.count ?? 0) - 2 == $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                if let keyword = try? strongSelf.searchTextSubject.value() {
                    strongSelf.loadMovies(with: keyword)
                }
            }).disposed(by: disposeBag)
    }
    
    private func subscribeToSelectItem() {
        selectItemSubject
            .compactMap { try? self.searchResultsSubject.value()[$0].id }
            .subscribe(onNext: { [weak self] in
                self?.navigator.navigateToMovieDetails(with: $0, responder: self)
            }).disposed(by: disposeBag)
    }

}

extension SearchResultsViewModel: ToggledWatchlistResponder {
    public func didToggleWatchlist(for id: Int) {
        guard var value = (try? self.searchResultsSubject.value()),
              let index = value.firstIndex(where: { $0.id == id })
        else { return }
        
        var movie = value.remove(at: index)
        movie.isInWatchlist.toggle()
        value.insert(movie, at: index)
        self.searchResultsSubject.onNext(value)
    }
}
