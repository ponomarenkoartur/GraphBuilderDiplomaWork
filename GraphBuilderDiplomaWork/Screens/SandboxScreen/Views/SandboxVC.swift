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
    var didTapHomeButton: () -> () { get set }
    var didTapSettingsButton: () -> () { get set }
    var didTapCameraButton: () -> () { get set }
    var didTapChangeMode: (_ mode: PlotPresentationMode) -> () { get set }
    var didTapShowPlot: (_ show: Bool, _ index: Int) -> () { get set }
    var didSelectColorForPlot: (_ color: UIColor, _ index: Int) -> () { get set }
    var didTapDeleteEquation: (_ index: Int) -> () { get set }
    var didTapBack: () -> () { get set }
    func addPlot(_ plot: Plot)
    func removePlot(at index: Int)
    func setPlotList(_ list: [Plot])
}


class SandboxVC: BaseVC, SandboxVCProtocol {
    
    
    // MARK: - Properties
    
    private var plotsList: [Plot] = [] {
        didSet {
            tableViewPlotsListSubject.onNext(plotsList)
        }
    }
    private let tableViewPlotsListSubject = BehaviorSubject<[Plot]>(value: [])
    private let isEquationTableHiddenSubject =
        BehaviorSubject<Bool>(value: true)
    private var isEquationTableHidden: Bool {
        get { try! isEquationTableHiddenSubject.value() }
        set { isEquationTableHiddenSubject.onNext(newValue) }
    }
    private var tableViewVissibleOffset: CGFloat {
        -view.frame.height / 2
    }
    
    private let isColorPickerHiddenSubject =
        BehaviorSubject<Bool>(value: true)
    private var isColorPickerHidden: Bool {
        get { try! isColorPickerHiddenSubject.value() }
        set { isColorPickerHiddenSubject.onNext(newValue) }
    }
    private let plotScene = PlotScene()
    
    
    /// Index of row that caused appearing of `plotColorPicker`
    private var colorPickerRowTargetIndex: Int?
    
    private var tableViewDisposable: Disposable?
    
    
    // MARK: - Callbacks
    
    var didTapHomeButton: () -> () = { }
    var didTapSettingsButton: () -> () = { }
    var didTapCameraButton: () -> () = { }
    var didTapChangeMode: (_ mode: PlotPresentationMode) -> () = { _ in }
    var didTapShowPlot: (_ show: Bool, _ index: Int) -> () = { _, _ in }
    var didSelectColorForPlot: (_ color: UIColor, _ index: Int) -> () = { _, _ in }
    var didTapDeleteEquation: (_ index: Int) -> () = { _ in }
    var didTapBack: () -> () = {}
    
    // MARK: Views
    
    private lazy var scnPlotView = PlotView(scene: plotScene)
    
    private lazy var buttonBack: UIButton = {
        let button = UIButton()
        button.setImage(Image.backButton())
        button.rx.tap.subscribe(onNext: { _ in self.didTapBack() })
            .disposed(by: bag)
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
    
    private lazy var tableViewFooter: UIView = {
        let view = UIView(frame: CGRect(width: self.view.frame.width,
                                        height: 100))
        view.backgroundColor = Color.grayBackground()
        return view
    }()
    
    private lazy var equationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SandboxEquationCell.self)
        tableView.backgroundColor = Color.grayBackground()
        tableView.rowHeight = 49
        tableView.tableHeaderView = UIView(frame: CGRect(height: 16))
        tableView.tableFooterView = tableViewFooter
        tableView.allowsSelection = false
        tableView.bounces = false
        tableView.layer.cornerRadius = 5
        tableView.rx
            .swipeGesture(.down)
            .when(.recognized)
            .subscribe(onNext: { _ in
                if tableView.contentOffset.y <= 0 {
                    self.isEquationTableHidden = true
                }
            })
            .disposed(by: bag)
        tableViewPlotsListSubject
            .bind(to: tableView.rx.items) { tableView, index, item in
                let cell = tableView
                    .dequeue(SandboxEquationCell.self, for: index) ??
                    SandboxEquationCell()
                self.prepare(cell, for: index, with: item)
                return cell
            }
            .disposed(by: bag)
        return tableView
    }()
    
    private lazy var plotColorPicker: PlotColorPickerView = {
        let plotColorPicker = PlotColorPickerView()
        plotColorPicker.didSelectColor = { color in
            self.isColorPickerHidden = true
            if let index = self.colorPickerRowTargetIndex {
                self.didSelectColorForPlot(color, index)
            }
            print("Color: \(color) selected")
        }
        return plotColorPicker
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        shouldPresentNavigationBar = false
        setupGestureRecognizers()
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews([
            scnPlotView,
            buttonBack, topRightButtonStackView,
            bottomButtonStackView,
            equationsTableView,
            plotColorPicker
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
        scnPlotView.snp.makeConstraints { $0.edges.equalToSuperview() }
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
            $0.height.equalTo(
                -tableViewVissibleOffset + WindowSafeArea.insets.bottom
                + equationsTableView.layer.cornerRadius)
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.bottom)
        }
        plotColorPicker.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(63)
            $0.top.equalToSuperview()
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
        
        isColorPickerHiddenSubject
            .subscribe(onNext: { isHidden in
                UIView.animate(withDuration: 0.2) {
                    self.plotColorPicker.alpha = isHidden ? 0 : 1
                }
            })
            .disposed(by: bag)
    }
    
    private func setupGestureRecognizers() {
        view.rx
            .panGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in self.isColorPickerHidden = true })
            .disposed(by: bag)
        equationsTableView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in self.isColorPickerHidden = true })
            .disposed(by: bag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.isColorPickerHidden = true
    }
    
    
    // MARK: - API Methods
    
    func addPlot(_ plot: Plot) {
        plotsList.append(plot)
        plotScene.add(plot)
    }
    
    func removePlot(at index: Int) {
        plotsList.remove(at: index)
        plotScene.deletePlot(at: index)
    }
    
    func setPlotList(_ list: [Plot]) {
        plotsList = list
        plotScene.deleteAll()
        plotsList.forEach { plotScene.add($0) }
    }
    
    
    // MARK: - Other Methods
    
    private enum ButtonDirection { case up, down }
    private func setOpenHidePlotButtonDirection(_ direction: ButtonDirection) {
        openHidePlotEditorButton.transform =
            CGAffineTransform(rotationAngle: direction == .up ? 0 : .pi)
    }
    
    private func prepare(_ cell: SandboxEquationCell, for index: Int,
                         with item: Plot) {
        SandboxEquationCellConfigurator(cell: cell)
            .configure(with: (index, item))
        cell.didTapPlotImageButton = {
            self.didTapShowPlot(item.isHidden, index)
            self.isColorPickerHidden = true
        }
        cell.didLongPressPlotImageButton = {
            self.colorPickerRowTargetIndex = index
            self.isColorPickerHidden = false
            self.movePlotColorPickerToCell(at: index)
        }
        cell.didTapDeleteButton = {
            self.didTapDeleteEquation(index)
        }
    }
    
    private func movePlotColorPickerToCell(at index: Int) {
        let rect = self.equationsTableView.rectForRow(at: IndexPath(row: index))
        let rectOfCellInSuperview = equationsTableView.convert(rect, to: view)
        let absoluteYCellMiddle = rectOfCellInSuperview.midY
        
        var colorPickerYOffset =
            absoluteYCellMiddle - plotColorPicker.frame.height / 2
        
        let minPickerOffset =
            equationsTableView.frame.minY - plotColorPicker.frame.height / 2
            + equationsTableView.rowHeight / 2
        let maxPickerOffset =
            view.frame.height - plotColorPicker.frame.height
                - WindowSafeArea.insets.bottom - 5
        
        if colorPickerYOffset > maxPickerOffset {
            colorPickerYOffset = maxPickerOffset
            let scrollOffset = equationsTableView.tableHeaderView!.frame.height
                + equationsTableView.rowHeight * (CGFloat(index) + 1.5)
                - equationsTableView.frame.height
                + equationsTableView.layer.cornerRadius
                + WindowSafeArea.insets.bottom * 2
            equationsTableView.setContentOffset(CGPoint(x: 0, y: scrollOffset),
                                                animated: true)
        } else if colorPickerYOffset < minPickerOffset {
            colorPickerYOffset = minPickerOffset
            let scrollOffset =
                equationsTableView.tableHeaderView!.frame.height +
                equationsTableView.rowHeight * (CGFloat(index))
            equationsTableView.setContentOffset(CGPoint(x: 0, y: scrollOffset),
                                                animated: true)
        }
        self.plotColorPicker.snp.updateConstraints {
            $0.top.equalToSuperview().offset(colorPickerYOffset)
        }
    }
}
