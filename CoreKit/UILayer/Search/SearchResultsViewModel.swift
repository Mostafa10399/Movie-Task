//
//  SearchResultsViewModel.swift
//  CoreKit
//
//  Created by Mostafa on 19/02/2025.
//

import Foundation
import Combine

public final class SearchResultsViewModel {
    
    // MARK: - Properties
    
    private let repository: SearchRepository
    private var nextPage = 1
    private var canLoadMore = true
    private let navigator: MovieDetailsNavigator
    private let searchResultsSubject = CurrentValueSubject<[MovieListPresentable], Never>([])
    private let errorMessagesSubject = PassthroughSubject<ErrorMessage, Never>()
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    public let errorPresentation = CurrentValueSubject<ErrorPresentation?, Never>(nil)
    public let searchTextSubject = CurrentValueSubject<String?, Never>(nil)
    public let currentDisplayedItemSubject = PassthroughSubject<Int, Never>()
    public let selectItemSubject = PassthroughSubject<Int, Never>()
    
    public var list: AnyPublisher<[MovieListPresentable], Never> {
        searchResultsSubject.eraseToAnyPublisher()
    }
    public var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    public var errorMessagesPublisher: AnyPublisher<ErrorMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    public var searchTextSubscriber: AnySubscriber<String?, Never> {
        AnySubscriber(searchTextSubject)
    }
    // State
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    
    public init(repository: SearchRepository, navigator: MovieDetailsNavigator) {
        self.repository = repository
        self.navigator = navigator
        self.subscribeToSearch()
        self.subscribeToLoadMore()
        self.subscribeToSelectItem()
    }
    
    private func loadMovies(with keyword: String) {
        isLoadingSubject.send(true)
        Task { [weak self] in
            guard let strongSelf = self else { return }
            defer { strongSelf.isLoadingSubject.send(false) }
            do {
                let newMovies = try await strongSelf.repository.search(query: keyword, page: strongSelf.nextPage).map(MovieListPresentable.init)
                await MainActor.run {
                    var currentMovies = strongSelf.searchResultsSubject.value
                    currentMovies.append(contentsOf: newMovies)
                    strongSelf.searchResultsSubject.send(currentMovies)
                    strongSelf.nextPage += 1
                    strongSelf.canLoadMore = !newMovies.isEmpty
                    
                }
            } catch {
                await MainActor.run {
                    strongSelf.errorMessagesSubject.send(ErrorMessage(error: error))
                }
            }
        }
    }
    
    private func subscribeToSearch() {
        searchTextSubject
            .compactMap { $0 }
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let strongSelf = self else { return }
                strongSelf.searchResultsSubject.send([])
                strongSelf.nextPage = 1
                strongSelf.canLoadMore = true
                if !searchText.isEmpty {
                    strongSelf.loadMovies(with: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToLoadMore() {
        currentDisplayedItemSubject
            .filter { $0 > 0 }
            .filter { [weak self] index in
                guard let strongSelf = self else { return false }
                return (strongSelf.searchResultsSubject.value.count - 2) == index
            }
            .sink { [weak self] _ in
                guard let strongSelf = self else { return }
                if let keyword = strongSelf.searchTextSubject.value {
                    strongSelf.loadMovies(with: keyword)
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func subscribeToSelectItem() {
        selectItemSubject
            .compactMap { [weak self] index in
                return self?.searchResultsSubject.value[index].id
            }
            .sink { [weak self] movieId in
                if let strongSelf = self {
                    strongSelf.navigator.navigateToMovieDetails(with: movieId, responder: strongSelf)

                }
            }
            .store(in: &cancellables)
    }

}

extension SearchResultsViewModel: ToggledWatchlistResponder {
    public func didToggleWatchlist(for id: Int) {
        var movies = searchResultsSubject.value
        guard let index = movies.firstIndex(where: { $0.id == id }) else { return }
        movies[index].isInWatchlist.toggle()
        searchResultsSubject.send(movies)
    }
}
