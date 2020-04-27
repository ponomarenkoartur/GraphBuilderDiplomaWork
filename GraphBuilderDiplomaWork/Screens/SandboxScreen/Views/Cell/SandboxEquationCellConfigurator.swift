//
//  SandboxEquationCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class SandboxEquationCellConfigurator:
    BaseTableCellConfigurator<(Int, SandboxEquation), SandboxEquationCell> {
    
    override func configure(with data: (index: Int, sandboxEquation: SandboxEquation)) {
        let cell = item
        cell.setOrderNumber(data.index + 1)
        cell.setPlotImageColor(data.sandboxEquation.color)
        cell.setEquation(data.sandboxEquation.equation)
        cell.setPlotImageTransparancy(data.sandboxEquation.isHidden ? 0.1 : 1)
    }
    
}
