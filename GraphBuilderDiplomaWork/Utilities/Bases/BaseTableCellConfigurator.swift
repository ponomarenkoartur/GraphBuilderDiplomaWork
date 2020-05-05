//
//  BaseTableCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class BaseTableCellConfigurator<Data, Cell>: Configurator
    where Cell: UITableViewCell {
    

    // MARK: - Typealiases
    
    typealias Item = Cell
    typealias Data = Data 
    
    // MARK: - Properties
    
    var item: Cell
    var cell: Cell { item }
    
    
    // MARK: - Initialization
    
    init(cell: Cell) {
        self.item = cell
    }
    
    // MARK: - API Methods
    
    func configure(with data: Data) {}
}
