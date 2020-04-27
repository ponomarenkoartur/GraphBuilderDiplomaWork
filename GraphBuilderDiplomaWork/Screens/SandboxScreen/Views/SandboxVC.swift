//
//  SandboxVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 24.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift
import ARKit


protocol SandboxVCProtocol: UIViewController {
    func setEquationsList(_ list: [Equation])
}


class SandboxVC: BaseVC, SandboxVCProtocol {
    
    
    // MARK: - Properties
    
    private let equationsSubject = BehaviorSubject<[Equation]>(value: [])
    private let isEquationTableHiddenSubject =
        BehaviorSubject<Bool>(value: true)
    private var isEquationTableHidden: Bool {
        get { try! isEquationTableHiddenSubject.value() }
        set { isEquationTableHiddenSubject.onNext(newValue) }
    }
    private var tableViewVissibleOffset: CGFloat {
        -view.frame.height / 2
    }
    
    
    // MARK: - Callbacks
    
    var didTapHomeButton: () -> () = { }
    var didTapSettingsButton: () -> () = { }
    var didTapCameraButton: () -> () = { }
    var didTapChangeMode: (_ mode: PlotPresentationMode) -> () = { _ in }
    
    // MARK: Views
    
    private lazy var arView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var buttonBack: UIButton = {
        let button = UIButton()
        button.setImage(Image.backButton())
        return button
    }()
    
    private lazy var topRightButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var takePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.camera())
        button.rx.tap.subscribe(onNext: { _ in self.didTapCameraButton() })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.settings())
        button.rx.tap.subscribe(onNext: { _ in self.didTapSettingsButton() })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.home())
        button.tintColor = Color.inverseText()
        button.rx.tap.subscribe(onNext: { _ in self.didTapHomeButton() })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var bottomButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var manipilationModeSwitchButton: UIButton = {
        let button = UIButton()
        button.tintColor = Color.inverseText()
        button.setImage(Image.cube3D(), for: .normal)
        button.setImage(Image.cube3DDotted(), for: .selected)
        button.isSelected = false
        button.rx.tap
            .subscribe(onNext: { _ in
                button.isSelected = !button.isSelected
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
                button.layer.add(transition, forKey: nil)
            })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var xyzControl: XYZControl = {
        let control = XYZControl()
        control.axisesSelection = (true, true, true)
        control.snp.makeConstraints { $0.size.equalTo(84) }
        return control
    }()
    
    private lazy var openHidePlotEditorButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.doubleArrowUp(), for: .normal)
        button.rx.tap
            .subscribe(onNext: { _ in
                self.isEquationTableHidden = !self.isEquationTableHidden
            })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var equationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SandboxEquationCell.self)
        tableView.backgroundColor = Color.grayBackground()
        tableView.rowHeight = 49
        tableView.tableHeaderView = UIView(frame: CGRect(height: 16))
        tableView.allowsSelection = false
        tableView.rx
            .swipeGesture(.down)
            .when(.recognized)
            .subscribe(onNext: { _ in
                if tableView.contentOffset.y <= 0 {
                    self.isEquationTableHidden = true
                }
            })
            .disposed(by: bag)
        return tableView
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        shouldPresentNavigationBar = false
        setupGestureRecognizers()
    }
    
    override func setupUIAfterLayoutSubviews() {
        super.setupUIAfterLayoutSubviews()
        equationsTableView.round([.topLeft, .topRight], radius: 10)
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews([
            arView,
            buttonBack, topRightButtonStackView,
            bottomButtonStackView,
            equationsTableView
        ])
        topRightButtonStackView.addArrangedSubviews([
            takePhotoButton,
            settingsButton,
            homeButton,
        ])
        bottomButtonStackView.addArrangedSubviews([
            manipilationModeSwitchButton, xyzControl, openHidePlotEditorButton
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        arView.snp.makeConstraints { $0.edges.equalToSuperview() }
        buttonBack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(10)
        }
        topRightButtonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalTo(-10)
        }
        bottomButtonStackView.snp.makeConstraints {
            $0.bottom.equalTo(equationsTableView.snp.top)
                .offset(-WindowSafeArea.insets.bottom - 10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-34)
        }
        equationsTableView.snp.makeConstraints {
            $0.height.equalTo(view.snp.height).multipliedBy(0.66)
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.bottom)
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        isEquationTableHiddenSubject
            .subscribe(onNext: { isHidden in
                UIView.animate(
                    withDuration: self.didAppear ? 0.2 : 0, delay: 0,
                    options: [.curveEaseOut], animations: {
                        self.bottomButtonStackView.snp.updateConstraints {
                            $0.bottom.equalTo(self.equationsTableView.snp.top)
                                .offset(isHidden ? (-WindowSafeArea.insets.bottom - 10) : 0)
                        }
                        self.equationsTableView.snp.updateConstraints {
                            $0.top.equalTo(self.view.snp.bottom)
                                .offset(isHidden ? 0 : self.tableViewVissibleOffset)
                        }
                        self.view.layoutSubviews()
                        self.setOpenHidePlotButtonDirection(
                            isHidden ? .up : .down)
                })
            })
            .disposed(by: bag)
        
        equationsSubject
            .bind(to: equationsTableView.rx.items) {
                (tableView: UITableView, index: Int, item: Equation) in
                let cell = tableView
                    .dequeue(SandboxEquationCell.self, for: index) ??
                    SandboxEquationCell()
                SandboxEquationCellConfigurator(cell: cell)
                    .configure(with: (index, item))
                return cell
            }
            .disposed(by: bag)
    }
    
    private func setupGestureRecognizers() {
        view.rx
            .swipeGesture([.up])
            .when(.recognized)
            .subscribe(onNext: { _ in self.isEquationTableHidden = false })
            .disposed(by: bag)
    }
    
    
    // MARK: - API Methods
    
    func setEquationsList(_ list: [Equation]) {
        equationsSubject.onNext(list)
    }
    
    // MARK: - Other Methods
    
    private enum ButtonDirection { case up, down }
    private func setOpenHidePlotButtonDirection(_ direction: ButtonDirection) {
        openHidePlotEditorButton.transform =
            CGAffineTransform(rotationAngle: direction == .up ? 0 : .pi)
    }
}
