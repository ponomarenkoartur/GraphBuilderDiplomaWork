//
//  Array extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 13.03.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


extension Array {
    func appending(contentsOf otherSequence: Array) -> Array {
        var selfCopy = self
        selfCopy.append(contentsOf: otherSequence)
        return selfCopy
    }
    
    func appending(_ element: Element) -> Array {
        var selfCopy = self
        selfCopy.append(element)
        return selfCopy
    }
    
    func hasIndex(_ index: Int) -> Bool {
        return index >= 0 && index < count
    }
    
    var lastIndex: Int {
        return self.count - 1
    }
    
    func safeSubscript(_ index: Int) -> Element? {
        hasIndex(index) ? self[index] : nil
    }
    
    mutating func appendIfNotNil(_ element: Element?) {
        if let element = element {
            append(element)
        }
    }
    
    func firstHalf() -> ArraySlice<Element> {
        guard !self.isEmpty else { return [] }
        return self[0..<(count / 2)]
    }
    
    func secondHalf() -> ArraySlice<Element> {
        guard !self.isEmpty else { return [] }
        return self[(count / 2)...]
    }
    
    
    func removingDuplicates(
        equalPredicate: (_ lhs: Element, _ rhs: Element) -> Bool) -> Array {
        var unique: Array<Element> = []
        self.forEach { item in
            if !unique.contains(where: { equalPredicate($0, item) }) {
                unique.append(item)
            }
        }
        return unique
    }
    
    mutating func removeAllExceptIntersect<T>(
        with other: Array<T>,
        equalPredicate: (_ lhs: Element, _ rhs: T) -> Bool) {
        removeAll { item in
            !other.contains(where: { equalPredicate(item, $0) })
        }
    }
    
    func removingAllIntersection<T>(
        with other: Array<T>,
        equalPredicate: (_ lhs: Element, _ rhs: T) -> Bool) -> Array {
        filter { item in
            !other.contains(where: { equalPredicate(item, $0) })
        }
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> Array {
        var set = Set<Element>()
        var unique: Array<Element> = []
        self.forEach {
            if !set.contains($0) {
                set.insert($0)
                unique.append($0)
            }
        }
        return unique
    }
}

extension Array where Element: Equatable {
    mutating func removeAllExceptIntersect(with other: Array) {
        removeAll { item in
            !other.contains(where: { item == $0 })
        }
    }
}
