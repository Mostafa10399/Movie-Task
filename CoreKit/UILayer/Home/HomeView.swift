public enum HomeView: Equatable {
    case root
    case details(id: Int, responder: ToggledWatchlistResponder?)
    
    public func hidesNavigationBar() -> Bool {
        return false
    }
    
    public static func == (lhs: HomeView, rhs: HomeView) -> Bool {
        switch (lhs, rhs) {
        case (.root, .root),
            (.details, .details): return true
        default: return false
        }
    }
}