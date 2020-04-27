//
//  SandboxEquationCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class SandboxEquationCellConfigurator:
    BaseTableCellConfigurator<(Int, Equation), SandboxEquationCell> {
    
    override func configure(with data: (index: Int, equation: Equation)) {
        let cell = item
        cell.setOrderNumber(data.index + 1)
        cell.setPlotImageColor(UIColor.random())
        cell.setEquation(data.equation)
    }
    
}
