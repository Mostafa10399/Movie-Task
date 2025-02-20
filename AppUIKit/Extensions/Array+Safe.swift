//
//  Array+Safe.swift
//  Movies-Task
//
//  Created by Mostafa on 20/02/2025.
//
import Foundation

// MARK: - Safe Array Indexing Extension
public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
