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
    
}
