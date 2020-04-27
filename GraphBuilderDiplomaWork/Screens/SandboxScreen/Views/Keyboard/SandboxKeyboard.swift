//
//  SandboxKeyboard.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import iosMath


class SandboxKeyboard: BaseView {
    
    
    // MARK: - Internal Types
    
    private struct ButtonData {
        var text: String? = nil
        var latexText: String? = nil
        var action: () -> ()
    }
    
    private enum Variable: String, CaseIterable {
        case x, y, z
    }
    
    private enum TrigonometricOperator: String, CaseIterable {
        case sin, cos, tan, cot
    }
    
    private enum ArithmeticOperator: String, CaseIterable {
        case addition = "+"
        case subtraction = "–"
        case multiplication = "×"
        case division = "÷"
    }
    
    private enum CursorDirection: String {
        case left = "←", right = "→"
    }
    
    
    // MARK: - Constants
    
    private let rowsCountInColumn = 4
    
    
    // MARK: - Properties
    
    weak var target: UIKeyInput?
    
    private lazy var buttons: [[[ButtonData]]] = [
        [
            Variable.allCases.map { variable in
                ButtonData(text: variable.rawValue, action: {
                    self.variableTapped(variable)
                })
            },
            [
                ButtonData(latexText: "a^2", action: secondPowerTapped),
                ButtonData(latexText: "a^b", action: powerTapped),
                ButtonData(latexText: "\\sqrt{x}", action: squareTapped),
            ],
            TrigonometricOperator.allCases.firstHalf().map { `operator` in
                ButtonData(text: `operator`.rawValue, action: {
                    self.trigonometricOperatorTapped(`operator`)
                })
            },
            TrigonometricOperator.allCases.secondHalf().map{ `operator` in
                ButtonData(text: `operator`.rawValue, action: {
                    self.trigonometricOperatorTapped(`operator`)
                })
            }
        ],
        [
            (7...9).map { number in
                ButtonData(text: String(number),
                           action: { self.numberTapped(Double(number)) })
            }.appending(
                ButtonData(text: ArithmeticOperator.division.rawValue,
                           action: { self.arithmeticOperatorTapped(.division) })
            ),
            (4...6).map { number in
                ButtonData(text: String(number),
                           action: { self.numberTapped(Double(number)) })
            }.appending(
                ButtonData(
                    text: ArithmeticOperator.multiplication.rawValue,
                    action: { self.arithmeticOperatorTapped(.multiplication) })
            ),
            (1...3).map { number in
                ButtonData(text: String(number),
                           action: { self.numberTapped(Double(number)) })
            }.appending(
                ButtonData(
                    text: ArithmeticOperator.subtraction.rawValue,
                    action: { self.arithmeticOperatorTapped(.subtraction) })
            ),
            [
                ButtonData(text: ".", action: pointTapped),
                ButtonData(text: "0", action: { self.numberTapped(0) }),
                ButtonData(text: "π", action: { self.numberTapped(.pi) }),
                ButtonData(text: ArithmeticOperator.addition.rawValue,
                           action: { self.arithmeticOperatorTapped(.addition) })
            ]
        ],
        [
            [ButtonData(text: CursorDirection.left.rawValue,
                        action: { self.moveCursosTapped(.left) })],
            [ButtonData(text: CursorDirection.right.rawValue,
                        action: { self.moveCursosTapped(.right) })],
            [ButtonData(text: "⌫", action: deleteButtonTapped)],
            [ButtonData(text: "↲", action: enterButtonTapped)],
        ],
    ]
    
    // MARK: - Actions
    
    private var variableTapped: (_ var: Variable) -> () = {
        print("\($0.rawValue) tapped")
    }
    private var secondPowerTapped: () -> () = {
        print("secondPowerTapped tapped")
    }
    private var powerTapped: () -> () = {
        print("powerTapped tapped")
    }
    private var squareTapped: () -> () = {
        print("squareTapped tapped")
    }
    private var trigonometricOperatorTapped:
        (_ operator: TrigonometricOperator) -> () = {
            print("\($0.rawValue) tapped")
    }
    private var numberTapped: (_ number: Double) -> () = {
        print("\($0) tapped")
    }
    private var arithmeticOperatorTapped:
        (_ operator: ArithmeticOperator) -> () = {
            print("\($0.rawValue) tapped")
    }
    private var pointTapped: () -> () = {
        print("pointTapped tapped")
    }
    private var moveCursosTapped: (_ direction: CursorDirection) -> () = {
        print("\($0.rawValue) tapped")
    }
    private var deleteButtonTapped: () -> () = {
        print("deleteButtonTapped tapped")
    }
    private var enterButtonTapped: () -> () = {
        print("enterButtonTapped tapped")
    }
    
    
    // MARK: Views
    
    //
    //  _____________________________________
    // |                  1                  |
    // |  _________   _________   _________  |
    // | |    2    | |    2    | |    2    | |
    // | |  _____  | |  _____  | |  _____  | |
    // | | |  3  | | | |  3  | | | |  3  | | |
    // | | |_____| | | |_____| | | |_____| | |
    // | |   ...   | |   ...   | |   ...   | |
    // | |   ...   | |   ...   | |   ...   | |
    // | |  _____  | |  _____  | |  _____  | |
    // | | |  3  | | | |  3  | | | |  3  | | |
    // | | |_____| | | |_____| | | |_____| | |
    // | |_________| |_________| |_________| |
    // |_____________________________________|
    //
    //  1 - superContainerStackView
    //  2 - columnStackViews
    //  3 - rowStackViews
    //
    
    private lazy var superContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var columnStackViews: [UIStackView] = {
        let stackViews = (0..<3).map { _ -> UIStackView in
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            stackView.spacing = 6
            stackView.axis = .vertical
            return stackView
        }
        return stackViews
    }()
    
    private lazy var rowStackViews: [UIStackView] = {
        let stackViews = (0..<columnStackViews.count * rowsCountInColumn).map {
            _ -> UIStackView in
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            stackView.spacing = 5
            stackView.axis = .horizontal
            return stackView
        }
        return stackViews
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(superContainerStackView)
        superContainerStackView.addArrangedSubviews(columnStackViews)
        for (rowIndex, rowStackView) in rowStackViews.enumerated() {
            let columnIndex = rowIndex / rowsCountInColumn
            let columnStackView = columnStackViews[safe: columnIndex]
            columnStackView?.addArrangedSubview(rowStackView)
        }
        
        columnStackViews.enumerated().forEach { (columnIndex, columnStackView) in
            columnStackView.arrangedSubviews
                .compactMap { $0 as? UIStackView }
                .enumerated()
                .forEach { (rowIndex, rowStackView) in
                    rowStackView.addArrangedSubviews(
                        buttons[safe: columnIndex]?[safe: rowIndex]?
                            .map { getButton(from: $0) } ?? []
                    )
            }
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        superContainerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().offset(-14)
        }
        
        columnStackViews.enumerated().forEach { (columnIndex, columnStackView) in
            columnStackView.snp.makeConstraints {
                switch columnIndex {
                case 0:
                    $0.width.equalTo(self.snp.width).multipliedBy(0.26)
                case 1:
                    $0.width.equalTo(self.snp.width).multipliedBy(0.36)
                case 2:
                    $0.width.equalTo(self.snp.width).multipliedBy(0.16)
                default:
                    break
                }
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func getButton(from buttonData: ButtonData) -> SandboxKeyboardButton {
        let button = SandboxKeyboardButton()
        button.latexText = buttonData.latexText
        button.text = buttonData.text
        button.rx.tap.subscribe(onNext: {
            buttonData.action()
        }).disposed(by: bag)
        return button
    }
}
