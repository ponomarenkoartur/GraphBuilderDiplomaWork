//
//  TopicPlotParameterCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class TopicPlotParameterCell: BaseTableViewCell {
    
    
    // MARK: - Properties
    
    
    private let parameterNameSubject = BehaviorSubject<String>(value: "a")
    var parameterName: String {
        get { try! parameterNameSubject.value() }
        set { parameterNameSubject.onNext(newValue) }
    }
    private let parameterValueSubject = BehaviorSubject<Float>(value: 0)
    var parameterValue: Float {
        get { try! parameterValueSubject.value() }
        set { parameterValueSubject.onNext(newValue) }
    }
    
    private let minParameterValueSubject = BehaviorSubject<Float>(value: -10)
    var minParameterValue: Float {
        get { try! minParameterValueSubject.value() }
        set { minParameterValueSubject.onNext(newValue) }
    }
    
    private let maxParameterValueSubject = BehaviorSubject<Float>(value: 10)
    var maxParameterValue: Float {
        get { try! maxParameterValueSubject.value() }
        set { maxParameterValueSubject.onNext(newValue) }
    }
    
    // MARK: Views
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var parameterLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.defaultText()
        label.font = Font.sfProDisplaySemibold(size: 15)
        return label
    }()
    
    private lazy var slider = UISlider()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .clear
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(stackView)
        stackView.addArrangedSubviews([
            parameterLabel, slider
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().offset(-32)
        }
        
        Observable.combineLatest(
            parameterValueSubject, minParameterValueSubject,
            maxParameterValueSubject)
            .subscribe(onNext: { value, min, max in
                self.slider.minimumValue = min
                self.slider.maximumValue = max
                self.slider.value = value
            })
            .disposed(by: bag)
        
        Observable.combineLatest(parameterNameSubject, parameterValueSubject)
            .subscribe(onNext: { name, value in
                self.parameterLabel.text = "\(name) = \(value)"
            })
            .disposed(by: bag)
    }
    
    
}
