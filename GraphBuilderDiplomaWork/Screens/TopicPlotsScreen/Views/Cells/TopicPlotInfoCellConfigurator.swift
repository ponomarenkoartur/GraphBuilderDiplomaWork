//
//  TopicPlotInfoCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


class TopicPlotInfoCellConfigurator:
    BaseCollectionCellConfigurator<(SerialPosition, Plot), TopicPlotInfoCell> {
    
    
    // MARK: - API Methods
    
    override func configure(with data: (position: SerialPosition, plot: Plot)) {
        let cell = item
        cell.previousPlotButton.isHidden = [.first, .alone].contains(data.position)
        cell.nextPlotButton.isHidden = [.last, .alone].contains(data.position)
        cell.setParametersList(data.plot.parameters)
        cell.setEquationText(data.plot.equation)
    }
    
}
