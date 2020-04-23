//
//  BaseCollectionCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit

class BaseCollectionCellConfigurator<Data, Cell>: Configurator
    where Cell: UICollectionViewCell {

    // MARK: - Typealiases
    
    typealias Item = Cell
    typealias Data = Data
    
    
    // MARK: - Properties
    
    var item: Cell
    
    
    // MARK: - Initialization
    
    init(cell: Cell) {
        self.item = cell
    }
    
    // MARK: - API Methods
    
    func configure(with data: Data) {}
}
