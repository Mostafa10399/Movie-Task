//
//  MovieDetailsViewModel.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import Foundation
import Combine

public final class MovieDetailsViewModel {
    
    // MARK: - Properties
    
    private let repository: MovieDetailsRepository
    private let id: Int
    private let responder: ToggledWatchlistResponder
    private let movieDetailsSubject = CurrentValueSubject<[MovieDetail], Never>([])
    private let errorMessagesSubject = PassthroughSubject<ErrorMessage, Never>()
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    public var list: AnyPublisher<[MovieDetail], Never> {
        movieDetailsSubject.eraseToAnyPublisher()
    }
    public var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    public var errorMessagesPublisher: AnyPublisher<ErrorMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    public let errorPresentation = CurrentValueSubject<ErrorPresentation?, Never>(nil)

    // State
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    
    public init(
        withId id: Int,
        repository: MovieDetailsRepository,
        responder: ToggledWatchlistResponder
    ) {
        self.repository = repository
        self.id = id
        self.responder = responder
        self.getData()
        self.getSimilarMovies()
    }
    
    private func getData() {
        Task { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingSubject.send(true)
            defer { strongSelf.isLoadingSubject.send(false) }
            do {
                let movieDetails = try await strongSelf.repository.getMovieDetails(withId: strongSelf.id)
                let presentableDetails = MovieDetailsPresentable(movieDetails)
                await MainActor.run {
                    var value = strongSelf.movieDetailsSubject.value
                    value.append(MovieDetail.movie(presentableDetails))
                    strongSelf.movieDetailsSubject.send(value)
                }
            } catch {
                await MainActor.run {
                    strongSelf.errorMessagesSubject.send(ErrorMessage(error: error))
                }
            }
        }
    }

    private func getSimilarMovies() {
        Task { [weak self] in
            guard let strongSelf = self else { return }
            do {
                let similarMovies = try await strongSelf.repository.getSimilarMovies(to: strongSelf.id, page: nil)
                    .prefix(5)
                    .compactMap(MovieListPresentable.init)
                await MainActor.run {
                    var value = strongSelf.movieDetailsSubject.value
                    value.append(MovieDetail.similar(Array(similarMovies)))
                    strongSelf.movieDetailsSubject.send(value)
                }
                let castResults = try await withThrowingTaskGroup(of: [CrewMember].self) { group in
                    for movie in similarMovies {
                        group.addTask {
                            try await strongSelf.repository.getCast(for: movie.id)
                        }
                    }
                    var allCasts: [[CrewMember]] = []
                    for try await cast in group {
                        allCasts.append(cast)
                    }
                    return allCasts.flatMap { $0 }
                }
                let groupedCast = Dictionary(grouping: castResults, by: { $0.knownForDepartment ?? "" })
                let topActors = groupedCast["Acting"]?
                    .sorted(by: { ($0.popularity ?? 0.0) > ($1.popularity ?? 0.0) })
                    .prefix(5)
                    .compactMap(CastMemberPresentable.init)

                let topDirectors = groupedCast["Directing"]?
                    .sorted(by: { ($0.popularity ?? 0.0) > ($1.popularity ?? 0.0) })
                    .prefix(5)
                    .compactMap(CastMemberPresentable.init)

                // Update movie details with actors and directors
                await MainActor.run {
                    var value = strongSelf.movieDetailsSubject.value
                    if let actors = topActors { value.append(MovieDetail.actors(actors)) }
                    if let directors = topDirectors { value.append(MovieDetail.directors(directors)) }
                    strongSelf.movieDetailsSubject.send(value)
                }
                
            } catch {
                await MainActor.run {
                    strongSelf.errorMessagesSubject.send(ErrorMessage(error: error))
                }
            }
        }
    }


    // MARK: - Actions
    
    @objc
    public func toggleWatchlist() {
        Task { [weak self] in
            guard let strongSelf = self else { return }
            do {
                let isInWatchlist = try await strongSelf.repository.toggleWatchlist(for: strongSelf.id)
                strongSelf.responder.didToggleWatchlist(for: strongSelf.id)

                var value = strongSelf.movieDetailsSubject.value
                guard let movieDetailsIndex = value.firstIndex(where: {
                    if case .movie = $0 { return true }
                    return false
                }) else { return }

                if case .movie(var movie) = value.remove(at: movieDetailsIndex) {
                    movie.isInWatchlist = isInWatchlist
                    value.append(.movie(movie))
                    strongSelf.movieDetailsSubject.send(value)
                }
            } catch {
                print("Error toggling watchlist: \(error)")
            }
        }
    }


}
