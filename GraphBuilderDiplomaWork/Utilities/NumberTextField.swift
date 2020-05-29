//
//  NumberTextField.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 01.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class NumberTextField: CustomTextField {
    
    
    // MARK: - Constants
    
    let decimalSeparator = NumberFormatter().decimalSeparator!
    
    
    // MARK: - Properties
    
    fileprivate let numberValueSubject = BehaviorSubject<Double>(value: 0)
    fileprivate let didBeginEditingSubject = PublishSubject<Bool>()
    fileprivate let didReturnSubject = PublishSubject<Bool>()
    fileprivate let numberValueUserInputSubject =
        BehaviorSubject<Double?>(value: nil)
    var numberValue: Double {
        get { try! numberValueSubject.value() }
        set { numberValueSubject.onNext(newValue) }
    }
    private let bag = DisposeBag()
    private var hasDecimalSeparator = false
    
    override var delegate: UITextFieldDelegate? {
        didSet {
            if delegate !== self {
                fatalError(
                    "The `NumberTextField` class must be delegate of itself"
                )
            }
        }
    }
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        isPasteEnabled = false
        keyboardType = .numbersAndPunctuation
        delegate = self
        numberValueSubject
            .subscribe(onNext: { self.setText($0) })
            .disposed(by: bag)
    }
    
    
    // MARK: - Private Methods
    
    private func setText(_ value: Double) {
        if value.isInteger  {
            var newText = "\(value)"
            newText.removeLast()
            if !hasDecimalSeparator {
                newText.removeLast()
            }
            self.text = newText
        } else {
            self.text = String(value)
        }
    }
    
    private func setNumberValue(_ value: Double, isUserInput: Bool) {
        numberValue = value
        if isUserInput {
            numberValueUserInputSubject.onNext(value)
        }
    }
}


// MARK: - UITextFieldDelegate

extension NumberTextField: UITextFieldDelegate {
    func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        
        let oldText = self.text! as NSString
        var newText = oldText.replacingCharacters(in: range, with: string)
        hasDecimalSeparator = newText.contains(decimalSeparator)
        
        if (oldText.contains("-") && string.contains("-")) ||
            newText.contains(where: { !"0987654321.-".contains($0) }) ||
            (oldText != "0" && string == "-") ||
            (oldText.contains(".") && string.contains(".")) {
            return false
        }
        
        if oldText == "0", string != "." {
            newText = string
        }
        
        if newText == "" {
            newText = "0"
        }
        
        if oldText == "-", string == "." {
            newText = "-0."
        }

        if let value = Double(newText), !String(value).contains("e") {
            setNumberValue(value, isUserInput: true)
        } else {
            self.text = newText
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditingSubject.onNext(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if Double(textField.text!) == nil {
            setNumberValue(0, isUserInput: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didReturnSubject.onNext(true)
        return true
    }
    
}


// MARK: Rx

extension Reactive where Base == NumberTextField {
    var numberValue: Observable<Double> {
        base.numberValueSubject.asObservable()
    }
    var numberValueUserInput: Observable<Double?> {
        base.numberValueUserInputSubject.asObservable()
    }
    var didBeginEditing: Observable<Bool> {
        base.didBeginEditingSubject.asObservable()
    }
    var didReturn: Observable<Bool> {
        base.didReturnSubject.asObservable()
    }
}
