//
//  HomeRootViewModel.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//

import Foundation
import Combine

public final class HomeRootViewModel {
    
    // MARK: - Properties
    
    public var errorPresentation = CurrentValueSubject<ErrorPresentation?, Never>(nil)
    private let errorMessagesSubject = PassthroughSubject<ErrorMessage, Never>()
    private let selectedViewSubject = CurrentValueSubject<OrderListSubview, Never>(.popular)
    public var errorMessagesPublisher: AnyPublisher<ErrorMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    var selectedViewPublisher: AnyPublisher<OrderListSubview, Never> {
        selectedViewSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    
    public init() {}
    
    @objc
    public func startSearching() {
        selectedViewSubject.send(.search)
    }
    
    @objc
    public func endSearching() {
        selectedViewSubject.send(.popular)
    }
}


public enum OrderListSubview: Int, CaseIterable {
    case popular, search
}
