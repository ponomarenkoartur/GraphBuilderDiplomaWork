//
//  String extension.swift
//  Agate
//
//  Created by Developer on 8/13/19.
//  Copyright © 2019 Agate. All rights reserved.
//

import UIKit

extension String {
    
    // MARK: - Properties
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
    
    var containsOnlyDigits: Bool {
        return CharacterSet.decimalDigits
            .isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    enum PaddingSide {
        case left, right
    }
    
    func padding(toLength length: Int, withPad pad: String,
                 from paddingSide: PaddingSide) -> String {
        let paddingCount = length - self.count
        guard paddingCount > 0 else {
            return self
        }
        
        let padding = [String](repeating: pad, count: paddingCount).joined()
        
        switch paddingSide {
        case .left:
            return padding + self
        case .right:
            return self + padding
        }
    }
    
    static var empty: String { "" }
    static var space: String { " " }
    
    mutating func replaceCharacter(at index: Int, _ newChar: Character) {
        var chars = Array(self)
        chars[index] = newChar
        self = String(chars)
    }
}


// MARK: - Subscripts

extension String {
    
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}
