//
//  SandboxEquationCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class SandboxEquationCellConfigurator:
    BaseTableCellConfigurator<(Int, Plot), SandboxEquationCell> {
    
    override func configure(with data: (index: Int, plot: Plot)) {
        let cell = item
        cell.setOrderNumber(data.index + 1)
        data.plot.rx.color
            .subscribe(onNext: { cell.setPlotImageColor($0) })
            .disposed(by: cell.bag)
        data.plot.rx.equation
            .subscribe(onNext: { cell.setEquation($0) })
            .disposed(by: cell.bag)
        data.plot.rx.isHidden
            .subscribe(onNext: { cell.setPlotImageTransparancy($0 ? 0.1 : 1) })
            .disposed(by: cell.bag)
        
        cell.equationTextField.rx.text
            .subscribe(onNext: {
                guard let text = $0 else { return }
                if data.plot.equation.latex != text {
                    data.plot.equation.latex = text
                    data.plot.equation.function = text
                }
            })
            .disposed(by: cell.bag)
    }
    
}
