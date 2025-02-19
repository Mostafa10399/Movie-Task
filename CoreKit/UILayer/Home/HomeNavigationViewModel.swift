import Foundation
import RxSwift

public typealias HomeNavigationAction = NavigationAction<HomeView>

public class HomeNavigationViewModel: MovieDetailsNavigator {

    // MARK: - Properties
    
    public var view: Observable<HomeNavigationAction> { return viewSubject.asObserver() }
    private let viewSubject = BehaviorSubject<HomeNavigationAction>(value: .present(view: .root))

    // MARK: - Methods
    
    public init() {
        
    }
    
    public func navigateToMovieDetails(with id: Int, responder: ToggledWatchlistResponder?) {
        viewSubject.onNext(.present(view: .details(id: id, responder: responder)))
    }
    
    public func uiPresented(view: HomeView) {
        viewSubject.onNext(.presented(view: view))
    }
}

public protocol MovieDetailsNavigator {
    func navigateToMovieDetails(with id: Int, responder: ToggledWatchlistResponder?)
}