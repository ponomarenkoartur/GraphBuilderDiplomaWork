//
//  SandboxEquationCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 24.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import iosMath
import RxSwift


protocol SandboxEquationCellProtocol {
    var didTapPlotImageButton: () -> () { get set }
    var didLongPressPlotImageButton: () -> () { get set }
    var didDoubleTap: () -> () { get set }
    var didChangeEquationText: (_ text: String) -> () { get set }
    var didTapSaveEquation: () -> () { get set }
    func setOrderNumber(_ number: Int)
    func setPlotImageColor(_ color: UIColor)
    func setPlotImageTransparancy(_ alpha: CGFloat)
    func setEquation(_ equation: Equation)
}

class SandboxEquationCell: BaseTableViewCell, SandboxEquationCellProtocol {
    
    
    // MARK: - Properties
    
    private let isLatexLabelHiddenSubject = BehaviorSubject(value: true)
    private var isLatexLabelHidden: Bool {
        get { try! isLatexLabelHiddenSubject.value() }
        set { isLatexLabelHiddenSubject.onNext(newValue) }
    }
    
    
    // MARK: Callbacks
    
    var didTapPlotImageButton: () -> () = {}
    var didLongPressPlotImageButton: () -> () = {}
    var didDoubleTap: () -> () = {}
    var didChangeEquationText: (_ text: String) -> () = { _ in }
    var didBeginEquationTextEditing: () -> () = {}
    var didTapSaveEquation: () -> () = {}
    
    // MARK: Views
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = Font.sfProDisplayRegular(size: 15)
        label.textColor = Color.turquoise()
        label.snp.makeConstraints { $0.width.equalTo(17) }
        return label
    }()
    
    private lazy var plotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { $0.size.equalTo(25) }
        imageView.image = Image.plotIcon()
        var longPressGR: UILongPressGestureRecognizer?
        imageView.rx
            .longPressGesture(configuration: { gr, _ in longPressGR = gr })
            .when(.recognized)
            .subscribe(onNext: { _ in self.didLongPressPlotImageButton() })
            .disposed(by: bag)
        imageView.rx
            .tapGesture(configuration: { (gr, delegate) in
                gr.require(toFail: longPressGR!)
            })
            .when(.recognized)
            .subscribe(onNext: { _ in self.didTapPlotImageButton() })
            .disposed(by: bag)
    
        return imageView
    }()
    
    private lazy var latexLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.font = MTFontManager().xitsFont(withSize: 15)
        label.textColor = Color.defaultText()!
        return label
    }()
    
    private lazy var equationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter equation here..."
        textField.borderStyle = .none
        textField.delegate = self
        textField.isHidden = true
        textField.rx.text
            .subscribe(onNext: {
                if let text = $0 {
                    self.didChangeEquationText(text)
                    self.latexLabel.latex = text
                }
            })
            .disposed(by: bag)
        return textField
    }()
    
    private lazy var equationsSavedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Image.equationSaved()
        imageView.tintColor = Color.turquoise()
        imageView.alpha = 0
        return imageView
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        setupGestures()
        backgroundColor = Color.grayBackground()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews(horizontalStackView, latexLabel, equationsSavedImageView)
        horizontalStackView.addArrangedSubviews([
            numberLabel,
            UIView.createSpacer(w: 3),
            plotImageView,
            UIView.createSpacer(w: 17),
            equationTextField,
            UIView(),
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        contentView.snp.makeConstraints { $0.height.equalTo(49) }
        horizontalStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().offset(-30)
            $0.height.equalToSuperview().offset(-10)
        }
        latexLabel.snp.makeConstraints {
            $0.centerY.equalTo(equationTextField.snp.centerY)
            $0.leading.equalTo(equationTextField.snp.leading)
        }
        equationsSavedImageView.snp.makeConstraints {
            $0.centerY.equalTo(horizontalStackView.snp.centerY)
            $0.trailing.equalTo(horizontalStackView.snp.trailing)
            $0.size.equalTo(horizontalStackView.snp.height)
        }
    }
    
    private func setupGestures() {
        rx.tapGesture { (gr, _) in gr.numberOfTapsRequired = 2 }
            .subscribe(onNext: { _ in self.didDoubleTap() })
            .disposed(by: bag)
        
        let tapGR = UITapGestureRecognizer(
            target: self, action: #selector(handleTap))
        latexLabel.addGestureRecognizer(tapGR)
    }
    
    @objc
    private func handleTap(_ gr: UITapGestureRecognizer) {
        guard gr.view == latexLabel else { return }
        equationTextField.becomeFirstResponder()
    }
    
    override func setupBinding() {
        super.setupBinding()
        isLatexLabelHiddenSubject
            .subscribe(onNext: { isHidden in
                self.latexLabel.isHidden = isHidden
                self.equationTextField.isHidden = !isHidden
            }).disposed(by: bag)
    }
    
    
    // MARK: - API Methods
    
    func setOrderNumber(_ number: Int) {
        numberLabel.text = String(number)
    }
    
    func setPlotImageColor(_ color: UIColor) {
        plotImageView.tintColor = color
    }
    
    func setPlotImageTransparancy(_ alpha: CGFloat) {
        plotImageView.alpha = alpha
    }
    
    func setEquation(_ equation: Equation) {
        latexLabel.latex = equation.latex
        equationTextField.text = equation.latex
        isLatexLabelHidden =
            equation.latex.isEmpty || equationTextField.isFirstResponder
    }
    
    
    // MARK: - Private Methods
    
    func performSavedAnimation() {
        // scale changes order:
        // 80ms:    static 60%
        // 200ms:   changes from 60% to 100%
        // 1040ms:  static 100%
        // 200ms:   changes from 100% to 60%
        equationsSavedImageView.transform =
            CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.2, delay: 0.08, animations: {
            self.equationsSavedImageView.transform = CGAffineTransform.identity
        }, completion: { (success) in
            UIView.animate(withDuration: 0.2, delay: 1.04, animations: {
                self.equationsSavedImageView.transform =
                    CGAffineTransform(scaleX: 0.6, y: 0.6)
            })
        })
        
        // opacity changes order:
        // 80ms:    static 0%
        // 40ms:    changes from 0% to 100%
        // 1400ms:  static 100%
        // 40ms:    changes from 100% to 0%
        equationsSavedImageView.alpha = 0
        UIView.animate(withDuration: 0.04, delay: 0.08, animations: {
            self.equationsSavedImageView.alpha = 1
        }, completion: { (success) in
            UIView.animate(withDuration: 0.04, delay: 1.4, animations: {
                self.equationsSavedImageView.alpha = 0
            })
        })
    }
}


// MARK: - UITextFieldDelegate

extension SandboxEquationCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEquationTextEditing()
        isLatexLabelHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isLatexLabelHidden = textField.text!.isEmpty
        return true
    }
}
