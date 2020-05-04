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
        return textField
    }()
    private(set) lazy var minParameterValueTextField: NumberTextField =
        Self.createNumberTextField()
    private(set) lazy var maxParameterValueTextField: NumberTextField =
        Self.createNumberTextField()
    
    
    
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.axis = .horizontal
        return stackView
    }()
    
    private(set) lazy var slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = Color.turquoise()
        slider.rx.value
            .subscribe(onNext: { value in
                let value = value.rounded()
                
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
