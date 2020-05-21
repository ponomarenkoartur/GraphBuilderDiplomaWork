//
//  Array extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 13.03.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


extension Array {
    subscript (safe range: PartialRangeFrom<Self.Index>) -> SubSequence? {
        guard let _ = self[safe: range.lowerBound] else {
            return nil
        }
        
        return self[range]
    }
    
    
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
    
    func combined<OtherElement>(with array: Array<OtherElement>)
        -> [(Element, OtherElement)] {
            Array<Any>.combine(self, with: array)
    }
    
    static func combine<E0, E1>(_ array0: Array<E0>, with array1: Array<E1>)
        -> [(E0, E1)] {
            var resultArray: [(E0, E1)] = []
            let count = Swift.min(array0.count, array1.count)
            for i in 0..<count {
                resultArray.append((array0[i], array1[i]))
            }
            return resultArray
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
    
    mutating func appendIfDoesntContain(_ element: Element) {
        if !self.contains(element) {
            append(element)
        }
    }
}
