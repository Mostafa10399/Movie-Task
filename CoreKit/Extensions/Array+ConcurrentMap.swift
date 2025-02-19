//
//  Array+concurrentMap.swift
//  Movies-Task
//
//  Created by Mostafa on 18/02/2025.
//


extension Array {
    func concurrentMap<T>(_ transform: @escaping (Element) async throws -> T) async throws -> [T] {
        try await withThrowingTaskGroup(of: (Int, T).self) { group in
            for (index, element) in self.enumerated() {
                group.addTask { (index, try await transform(element)) }
            }
            
            var results = Array<T?>(repeating: nil, count: count)
            for try await (index, result) in group {
                results[index] = result
            }
            
            return results.compactMap { $0 }
        }
    }
}
