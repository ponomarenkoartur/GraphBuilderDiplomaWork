//
//  PlotParameterCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class PlotParameterCell: BaseTableViewCell {
    
    
    // MARK: - Properties
    
    // MARK: Callbacks
    
    var didChangeSliderValue: (_ value: Double) -> () = { _ in }
    var didBeginEditingText: (_ textField: UITextField) -> () = { _ in }
    
    
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
    
    private(set) lazy var parameterValueTextField: NumberTextField = {
        let textField = Self.createNumberTextField()
        textField.font = Font.sfProDisplayRegular(size: 15)
        textField.rx.didBeginEditing
            .subscribe(onNext: { _ in self.didBeginEditingText(textField) })
            .disposed(by: bag)
        return textField
    }()
    private(set) lazy var minParameterValueTextField: NumberTextField = {
        let textField = Self.createNumberTextField()
        textField.rx.didBeginEditing
            .subscribe(onNext: { _ in self.didBeginEditingText(textField) })
            .disposed(by: bag)
        return textField
    }()
    private(set) lazy var maxParameterValueTextField: NumberTextField = {
        let textField = Self.createNumberTextField()
        textField.rx.didBeginEditing
            .subscribe(onNext: { _ in self.didBeginEditingText(textField) })
            .disposed(by: bag)
        return textField
    }()
    
    
    
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
            .throttle(.milliseconds(40), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                var value = Double($0)
                let delta = Double(slider.maximumValue - slider.minimumValue)
                var step: Double
                let multiplier = 10.0
                if delta > 1 {
                    step = 0.01
                    while step * 100 < delta {
                        step *= multiplier
                    }
                } else {
                    step = 0.1
                    while step * 100 > delta {
                        step /= multiplier
                    }
                }
                value = value.rounded(toPlaces: Int(-log10(step)))
                self.didChangeSliderValue(value)
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
    }
    
    
    // MARK: - API Methods
    
    func setName(_ name: String) {
        parameterLabel.text = "\(name): "
    }
    
    func setParameterValue(_ value: Double) {
        slider.value = Float(value)
        parameterValueTextField.numberValue = value
        
        let textWidth = self.parameterValueTextField.text!
            .attributedString
            .withFont(self.parameterValueTextField.font!)
            .size()
            .width
        let textFieldWidth = Swift.max(40, textWidth + 20)
        self.parameterValueTextField.snp.updateConstraints {
            $0.width.equalTo(textFieldWidth)
        }
    }
    
    func setMinParameterValue(_ value: Double) {
        slider.minimumValue = Float(value)
        minParameterValueTextField.numberValue = value
    }
    
    func setMaxParameterValue(_ value: Double) {
        slider.maximumValue = Float(value)
        maxParameterValueTextField.numberValue = value
    }
    
    
    // MARK: - Private Methods
    
    private static func createNumberTextField() -> NumberTextField {
        let textField = NumberTextField()
        textField.font = Font.sfProDisplayRegular(size: 10)
        textField.borderStyle = .roundedRect
        textField.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(25)
        }
        return textField
    }
    
}
