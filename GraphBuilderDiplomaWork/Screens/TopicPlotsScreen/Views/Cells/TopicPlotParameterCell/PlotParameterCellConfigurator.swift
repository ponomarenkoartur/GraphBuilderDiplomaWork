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
            .throttle(.milliseconds(40), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                let value = Double($0)
                let delta = data.maxValue - data.minValue
                var step = 1.0
                let multiplier = 10.0
                if delta > 1 {
                    while step * 100 < delta {
                        step *= multiplier
                    }
                } else {
                    while step * 10 > delta {
                        step /= multiplier
                    }
                }
                
                data.value = value.rounded(toPlaces: Int(-log10(step / 10)))
            })
            .disposed(by: cell.bag)
        cell.minParameterValueTextField.rx.numberValueUserInput
            .subscribe(onNext: { assignIfValueIsNotNil(&data.minValue, $0) })
            .disposed(by: cell.bag)
        cell.maxParameterValueTextField.rx.numberValueUserInput
            .subscribe(onNext: { assignIfValueIsNotNil(&data.maxValue, $0) })
            .disposed(by: cell.bag)
    }
    
} 
