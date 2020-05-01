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
    
    private lazy var parameterNameValueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var parameterLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.defaultText()
        label.font = Font.sfProDisplaySemibold(size: 15)
        return label
    }()
    
    private lazy var parameterValueTextField: NumberTextField =
        createNumberTextField()
    private lazy var minParameterValueTextField: NumberTextField =
        createNumberTextField()
    private lazy var maxParameterValueTextField: NumberTextField =
        createNumberTextField()
    
    
    
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = Color.turquoise()
        slider.rx.value
            .subscribe(onNext: { value in
                let value = value.rounded()
                self.parameterValue = value
                self.parameterValueTextField.numberValue = Double(value)
            })
            .disposed(by: bag)
        return slider
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(stackView)
        stackView.addArrangedSubviews(
            parameterNameValueStackView,
            middleStackView
        )
        parameterNameValueStackView.addArrangedSubviews(
            parameterLabel, parameterValueTextField, UIView()
        )
        middleStackView.addArrangedSubviews(
            minParameterValueTextField, slider, maxParameterValueTextField
        )
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
        
        parameterNameSubject
            .subscribe(onNext: { self.parameterLabel.text = "\($0): " })
            .disposed(by: bag)
        
        parameterValueTextField.rx.numberValue
            .subscribe(onNext: { value in
                let textWidth = self.parameterValueTextField.text!
                    .attributedString
                    .withFont(self.parameterValueTextField.font!)
                    .size()
                    .width
                let textFieldWidth = max(40, textWidth + 20)
                self.parameterValueTextField.snp.updateConstraints {
                    $0.width.equalTo(textFieldWidth)
                }
                self.parameterValue = Float(value)
            })
            .disposed(by: bag)
    }
    
    
    // MARK: - Private Methods
    
    private func createNumberTextField() -> NumberTextField {
        let textField = NumberTextField()
        textField.font = Font.sfProDisplayRegular(size: 15)
        textField.borderStyle = .roundedRect
        textField.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(25)
        }
        return textField
    }
    
}
