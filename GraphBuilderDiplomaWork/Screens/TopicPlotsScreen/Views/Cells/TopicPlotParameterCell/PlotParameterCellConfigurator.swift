//
//  PlotParameterCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class PlotParameterCellConfigurator:
    BaseTableCellConfigurator<EquationParameter, PlotParameterCell> {
    
    
    override func configure(with data: EquationParameter) {
        data.rx.name
            .subscribe(onNext: { self.cell.setName($0) })
            .disposed(by: cell.bag)
        data.rx.value
            .subscribe(onNext: { self.cell.setParameterValue($0) })
            .disposed(by: cell.bag)
        data.rx.minValue
            .subscribe(onNext: { self.cell.setMinParameterValue($0) })
            .disposed(by: cell.bag)
        data.rx.maxValue
            .subscribe(onNext: { self.cell.setMaxParameterValue($0) })
            .disposed(by: cell.bag)
        
        cell.parameterValueTextField.rx.numberValueUserInput
            .subscribe(onNext: { assignIfValueIsNotNil(&data.value, $0) })
            .disposed(by: cell.bag)
        cell.slider.rx.value
            .subscribe(onNext: { data.value = Double($0).rounded() })
            .disposed(by: cell.bag)
        cell.minParameterValueTextField.rx.numberValueUserInput
            .subscribe(onNext: { assignIfValueIsNotNil(&data.minValue, $0) })
            .disposed(by: cell.bag)
        cell.maxParameterValueTextField.rx.numberValueUserInput
            .subscribe(onNext: { assignIfValueIsNotNil(&data.maxValue, $0) })
            .disposed(by: cell.bag)
    }
    
} 
