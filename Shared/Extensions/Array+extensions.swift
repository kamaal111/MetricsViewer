//
//  Array+extensions.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 17/07/2021.
//

import Foundation

extension Array {
    /// Transforms `Array` to an `NSSet`
    public var asNSSet: NSSet {
        NSSet(array: self)
    }

    /// Adds a new element at the end of the array and returns the result.
    /// - Parameter newElement: The element to append to the array.
    /// - Returns: The result of the array with an appended element
    public func appended(_ newElement: Element) -> [Element] {
        self + [newElement]
    }
}
