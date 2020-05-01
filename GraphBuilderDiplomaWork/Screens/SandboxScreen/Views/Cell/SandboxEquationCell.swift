//
//  SandboxEquationCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 24.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import iosMath


protocol SandboxEquationCellProtocol {
    func setOrderNumber(_ number: Int)
    func setPlotImageColor(_ color: UIColor)
    func setPlotImageTransparancy(_ alpha: CGFloat)
    func setEquation(_ equation: Equation)
}

class SandboxEquationCell: BaseTableViewCell, SandboxEquationCellProtocol {
    
    
    // MARK: - Properties
    
    // MARK: Callbacks
    
    var didTapPlotImageButton: () -> () = {}
    var didLongPressPlotImageButton: () -> () = {}
    var didDoubleTap: () -> () = {}
    
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
    
    private lazy var equationLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.font = MTFontManager().xitsFont(withSize: 15)
        label.textColor = Color.defaultText()!
        return label
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = Color.grayBackground()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews([
            numberLabel,
            UIView.createSpacer(w: 3),
            plotImageView,
            UIView.createSpacer(w: 17),
            equationLabel,
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        horizontalStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().offset(-30)
        }
        contentView.snp.makeConstraints { $0.height.equalTo(49) }
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
        equationLabel.latex = equation.latex
    }
}
