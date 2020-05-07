//
//  Dictionary extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 07.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


extension Dictionary {
    mutating func removeAll(
        whereKey matchPredicate: (_ key: Dictionary.Key) -> Bool) {
        keys.filter { matchPredicate($0) }
            .forEach { removeValue(forKey: $0) }
    }
    
    mutating func removeAllExceptIntersectOfKeys<T>(
        with other: Array<T>,
        equalPredicate: (_ lhs: Key, _ rhs: T) -> Bool) {
        removeAll { item in
            !other.contains(where: { equalPredicate(item, $0) })
        }
    }
}
