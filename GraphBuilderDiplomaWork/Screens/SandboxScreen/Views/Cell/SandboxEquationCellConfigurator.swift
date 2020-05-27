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
        cell.resetExternalBinding()
        
        let cell = item
        cell.setOrderNumber(data.index)
        data.plot.rx.color
            .subscribe(onNext: { cell.setPlotImageColor($0) })
            .disposed(by: cell.externalBindingBag)
        data.plot.rx.equation
            .subscribe(onNext: { cell.setEquation($0) })
            .disposed(by: cell.externalBindingBag)
        data.plot.rx.isHidden
            .subscribe(onNext: { cell.setPlotImageTransparancy($0 ? 0.1 : 1) })
            .disposed(by: cell.externalBindingBag)
        data.plot.rx.error
            .subscribe(onNext: { cell.setError($0 != nil) })
            .disposed(by: cell.externalBindingBag)
    }
    
}
