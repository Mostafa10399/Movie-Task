//
//  WithConfigurable.swift
//  Movies-Task
//
//  Created by Mostafa on 19/02/2025.
//


import Foundation

public protocol WithConfigurable {}
public extension WithConfigurable where Self: AnyObject {
    @discardableResult
    func with(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: WithConfigurable {}
