//
//  SavedEquationsCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 26.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


class SavedEquationsCellConfigurator:
    BaseTableCellConfigurator<(Int, Equation), SavedEquationsCell> {
    
    
    // MARK: - API Methods
    
    override func configure(with data: (index: Int, equation: Equation)) {
        cell.setNumber(data.index)
        cell.setLatexText(data.equation.latex)
    }
}
