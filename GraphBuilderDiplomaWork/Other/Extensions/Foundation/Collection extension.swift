//
//  Collection extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    func hasIndex(_ index: Int) -> Bool {
        index >= 0 && index < count
    }
    
    func hasIndexes(_ indexes: Int...) -> Bool {
        for index in indexes {
            if !hasIndex(index) {
                return false
            }
        }
        return true
    }
    
    func hasIndexes(_ indexes: [Int]) -> Bool {
        for index in indexes {
            if !hasIndex(index) {
                return false
            }
        }
        return true
    }
    
    var lastIndex: Int {
        return self.count - 1
    }
}
