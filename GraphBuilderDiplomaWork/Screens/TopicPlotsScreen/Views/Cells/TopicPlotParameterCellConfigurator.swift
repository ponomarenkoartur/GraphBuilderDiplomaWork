//
//  TopicPlotParameterCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


class TopicPlotParameterCellConfigurator:
    BaseTableCellConfigurator<PlotEquationParameter, TopicPlotParameterCell> {
    
    
    override func configure(with data: PlotEquationParameter) {
        let cell = item
        cell.parameterName = data.name
        cell.parameterValue = data.value
    }
    
}
