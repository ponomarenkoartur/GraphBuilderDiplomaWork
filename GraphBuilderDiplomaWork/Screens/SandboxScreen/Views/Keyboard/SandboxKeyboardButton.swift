//
//  SandboxKeyboardButton.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import iosMath
import RxSwift
import UIFontComplete


class SandboxKeyboardButton: BaseButton {
    
    
    // MARK: - Properties
    
    private var latexTextSubject = BehaviorSubject<String?>(value: nil)
    var latexText: String? {
        get { try? latexTextSubject.value() }
        set { latexTextSubject.onNext(newValue) }
    }
    
    private var textSubject = BehaviorSubject<String?>(value: nil)
    var text: String? {
        get { try? textSubject.value() }
        set { textSubject.onNext(newValue) }
    }
    
    // MARK: Views
    
    private(set) lazy var latexTextLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.textColor = Color.defaultText()!
        label.font = MTFontManager().xitsFont(withSize: 15)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = Color.keyboardButtonBackground()
        setTitleColor(Color.defaultText())
        tintColor = Color.defaultText()
        titleLabel?.font = UIFont(font: .timesNewRomanPSItalicMT, size: 30)
        layer.cornerRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = Color.keyboardButtonShadow()?.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(latexTextLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        latexTextLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    override func setupBinding() {
        super.setupBinding()
        latexTextSubject
            .subscribe(onNext: { self.latexTextLabel.latex = $0 })
            .disposed(by: bag)
        textSubject
            .subscribe(onNext: { self.setTitle($0) })
            .disposed(by: bag)
    }
    
    
    // MARK: - API Methods
    
    func setFont(_ font: UIFont) {
        titleLabel?.font = font
    }
    
    func setLatexFont(_ font: MTFont) {
        latexTextLabel.font = font
    }
}
