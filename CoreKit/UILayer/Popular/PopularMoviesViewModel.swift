//
//  PopularMoviesViewModel.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import Foundation
import Combine
import UIKit

public final class PopularMoviesViewModel {
    
    // MARK: - Properties
    
    internal let repository: MovieRepository
    private let navigator: MovieDetailsNavigator
    private let popularMoviesSubject = CurrentValueSubject<[Int: [MovieListPresentable]], Never>([:])
    private let errorMessagesSubject = PassthroughSubject<ErrorMessage, Never>()
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    public let errorPresentation = CurrentValueSubject<ErrorPresentation?, Never>(nil)
    public let selectItemSubject = CurrentValueSubject<IndexPath, Never>([])
    
    public var list: AnyPublisher<[Int: [MovieListPresentable]], Never> {
        popularMoviesSubject.eraseToAnyPublisher()
    }
    public var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    public var errorMessagesPublisher: AnyPublisher<ErrorMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    public var selectedItemSubscriber: AnySubscriber<IndexPath, Never> {
        AnySubscriber(selectItemSubject)
    }
    
    private var cancelables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    
    public init(repository: MovieRepository, navigator: MovieDetailsNavigator) {
        self.repository = repository
        self.navigator = navigator
        self.getData()
        self.subscribeToSelectItem()
    }
    
    private func getData() {
        Task { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingSubject.send(true)
            defer { strongSelf.isLoadingSubject.send(false) }
            do {
                let movies = try await strongSelf.repository.getPopularMovies(page: 1)
                let presentables = movies.compactMap(MovieListPresentable.init)
                let groupedMovies = Dictionary(grouping: presentables, by: { $0.year })
                print(groupedMovies)
                await MainActor.run {
                    strongSelf.popularMoviesSubject.send(groupedMovies)
                }
            } catch {
                await MainActor.run {
                    strongSelf.errorMessagesSubject.send(ErrorMessage(error: error))
                }
            }
        }
    }
    
    private func subscribeToSelectItem() {
        selectItemSubject
            .dropFirst()
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                
                // Get the sorted keys (years) from the dictionary
                let sortedYears = self.popularMoviesSubject.value.keys.sorted()
                
                // Ensure the section index is within bounds
                guard indexPath.row < sortedYears.count else {
                    print("Error: Section \(indexPath.section) is out of bounds.")
                    return
                }
                
                let selectedYear = sortedYears[indexPath.row] // Get the correct key
                guard let movies = self.popularMoviesSubject.value[selectedYear], !movies.isEmpty else {
                    print("Error: No movies found for year \(selectedYear).")
                    return
                }
                
                // Ensure the row index is within bounds
                guard indexPath.section < movies.count else {
                    print("Error: Row \(indexPath.row) is out of bounds for section \(indexPath.section).")
                    return
                }
                
                let selectedMovie = movies[indexPath.section]
                print("Navigating to movie details: \(selectedMovie.id)")
                self.navigator.navigateToMovieDetails(with: selectedMovie.id, responder: self)
            }
            .store(in: &cancelables)
    }


}

extension PopularMoviesViewModel: ToggledWatchlistResponder {
    public func didToggleWatchlist(for id: Int) {
        getData()
    }
}

extension Array {
    func safe(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
