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
        var image: UIImage? = nil
        var font = UIFont(font: .timesNewRomanPSItalicMT, size: 30)!
        var latexText: String? = nil
        var latexFont: MTFont = MTFontManager().xitsFont(withSize: 25)
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
    
    
    private enum Constants {
        static let rowsCountInColumn = 4
    }
    
    
    // MARK: - Properties
    
    weak var target: UIKeyInput?
    
    private lazy var buttonsData: [[[ButtonData]]] = [
        [
            Variable.allCases.map { variable in
                ButtonData(text: variable.rawValue, action: {
                    self.variableTapped(variable)
                })
            },
            [
                ButtonData(latexText: "a^2", action: secondPowerTapped),
                ButtonData(latexText: "a^b", action: powerTapped),
                ButtonData(latexText: "\\sqrt{}",
                           latexFont: MTFontManager().xitsFont(withSize: 18),
                           action: squareTapped),
            ],
            TrigonometricOperator.allCases.firstHalf().map { `operator` in
                ButtonData(
                    text: `operator`.rawValue,
                    font: UIFont(font: .timesNewRomanPSItalicMT, size: 25)!,
                    action: { self.trigonometricOperatorTapped(`operator`) })
            },
            TrigonometricOperator.allCases.secondHalf().map{ `operator` in
                ButtonData(
                    text: `operator`.rawValue,
                    font: UIFont(font: .timesNewRomanPSItalicMT, size: 25)!,
                    action: { self.trigonometricOperatorTapped(`operator`) })
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
            [ButtonData(image: Image.deleteButton(),
                        action: deleteButtonTapped)],
            [ButtonData(image: Image.enterButton(), action: enterButtonTapped)],
        ],
    ]
    
    private var buttons: [SandboxKeyboardButton] = []
    
    
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
        let stackViews = (0..<columnStackViews.count * Constants.rowsCountInColumn).map {
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
        backgroundColor = Color.keyboardBackground()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(superContainerStackView)
        superContainerStackView.addArrangedSubviews(columnStackViews)
        for (rowIndex, rowStackView) in rowStackViews.enumerated() {
            let columnIndex = rowIndex / Constants.rowsCountInColumn
            let columnStackView = columnStackViews[safe: columnIndex]
            columnStackView?.addArrangedSubview(rowStackView)
        }
        
        columnStackViews.enumerated().forEach { (columnIndex, columnStackView) in
            columnStackView.arrangedSubviews
                .compactMap { $0 as? UIStackView }
                .enumerated()
                .forEach { (rowIndex, rowStackView) in
                    rowStackView.addArrangedSubviews(
                        buttonsData[safe: columnIndex]?[safe: rowIndex]?
                            .map {
                                let button = getButton(from: $0)
                                self.buttons.append(button)
                                return button
                            } ?? []
                    )
            }
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        self.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.height * 0.33)
        }
        
        superContainerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview()
                .offset(-(WindowSafeArea.insets.bottom + 15))
        }
        
        columnStackViews.enumerated().forEach { (columnIndex, columnStackView) in
            columnStackView.snp.makeConstraints {
                switch columnIndex {
                case 0:
                    $0.width.equalTo(self.snp.width).multipliedBy(0.28)
                case 1:
                    $0.width.equalTo(self.snp.width).multipliedBy(0.38)
                case 2:
                    $0.width.equalTo(self.snp.width).multipliedBy(0.18)
                default:
                    break
                }
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func getButton(from buttonData: ButtonData) -> SandboxKeyboardButton {
        let button = SandboxKeyboardButton()

        button.text = buttonData.text
        button.latexText = buttonData.latexText
        button.setFont(buttonData.font)
        button.setLatexFont(buttonData.latexFont)
        button.setImage(buttonData.image)
        
        button.rx.tap.subscribe(onNext: { buttonData.action() })
            .disposed(by: bag)
        return button
    }
}
