//
//  Configurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


protocol Configurator {
    associatedtype Item
    associatedtype Data
    
    var item: Item { get }
    func configure(with data: Data)
}
