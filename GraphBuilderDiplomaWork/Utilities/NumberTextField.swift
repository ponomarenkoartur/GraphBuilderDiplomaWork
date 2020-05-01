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
    var numberValue: Double {
        get { try! numberValueSubject.value() }
        set { numberValueSubject.onNext(newValue) }
    }
    private let bag = DisposeBag()
    private var hasDecimalSeparator = false
    
    
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
}


// MARK: - UITextFieldDelegate

extension NumberTextField: UITextFieldDelegate {
    func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        
        let oldText = self.text! as NSString
        var newText = oldText.replacingCharacters(in: range, with: string)
        hasDecimalSeparator = newText.contains(decimalSeparator)
        
        if oldText == "0", string != "." {
            newText = string
        }
        
        if newText == "" {
            newText = "0"
        }
        
        if newText.contains(where: { !"0987654321.".contains($0) }) {
            return false
        }

        if let value = Double(newText), !String(value).contains("e") {
            numberValue = value
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end")
    }
}


// MARK: Rx

extension Reactive where Base == NumberTextField {
    var numberValue: Observable<Double> {
        base.numberValueSubject.asObservable()
    }
}
