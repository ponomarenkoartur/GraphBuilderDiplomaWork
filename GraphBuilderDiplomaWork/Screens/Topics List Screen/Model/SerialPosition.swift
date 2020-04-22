//
//  SerialPosition.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


/// Represents position of item in sequence
enum SerialPosition {
    case first, middle, last
    
    static func get(forIndex index: Int, in sequence: Array<Any>) -> Self? {
        guard !sequence.isEmpty, sequence.hasIndex(index) else { return nil }
        
        switch index {
        case 0:
            return .first
        case sequence.lastIndex:
            return .last
        default:
            return .middle
        }
    }
}
