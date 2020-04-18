//
//  Set extension.swift
//  LimoDad
//
//  Created by artur_ios on 11.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import Foundation


extension Set {
    func intersects(with otherSet: Set) -> Bool {
        !intersection(otherSet).isEmpty
    }
}
