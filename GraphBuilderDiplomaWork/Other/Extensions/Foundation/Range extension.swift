//
//  Range extension.swift
//  LimoDad
//
//  Created by artur_ios on 07.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import Foundation


extension Range where Bound == String.Index {
    var nsRange:NSRange {
        NSRange(location: self.lowerBound.encodedOffset,
                   length: self.upperBound.encodedOffset -
                    self.lowerBound.encodedOffset)
    }
}
