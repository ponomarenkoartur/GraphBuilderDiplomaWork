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
import RxKeyboard


protocol SandboxVCProtocol: UIViewController {
    var didTapHomeButton: () -> () { get set }
    var didTapSettingsButton: () -> () { get set }
    var didTapCameraButton: () -> () { get set }
    var didTapAddPlot: () -> () { get set }
    var didTapChangeMode: (_ mode: PlotPresentationMode) -> () { get set }
    var didTapShowPlot: (_ show: Bool, _ index: Int) -> () { get set }
    var didSelectColorForPlot: (_ color: UIColor, _ index: Int) -> () { get set }
    var didChangeEquationText: (_ plot: Plot, _ index: Int, _ text: String) -> () { get set }
    var didTapDeleteEquation: (_ index: Int) -> () { get set }
    var didTapBack: () -> () { get set }
    func addPlot(_ plot: Plot)
    func removePlot(at index: Int)
    func setPlotList(_ list: [Plot])
    func updateParametersOfPlot(at index: Int)
}


class SandboxVC: BaseVC, SandboxVCProtocol {
    
    
    // MARK: - Properties
    
    private var plotsList: [Plot] = []

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
    
    /// IndexPath of cell that caused appearing of keyboard
    private var triggeredKeyboardCellIndexPath: IndexPath?
    
    
    // MARK: - Callbacks
    
    var didTapHomeButton: () -> () = { }
    var didTapSettingsButton: () -> () = { }
    var didTapCameraButton: () -> () = { }
    var didTapChangeMode: (_ mode: PlotPresentationMode) -> () = { _ in }
    var didTapShowPlot: (_ show: Bool, _ index: Int) -> () = { _, _ in }
    var didSelectColorForPlot: (_ color: UIColor, _ index: Int) -> () = { _, _ in }
    var didTapDeleteEquation: (_ index: Int) -> () = { _ in }
    var didTapBack: () -> () = {}
    var didTapAddPlot: () -> () = {}
    var didChangeEquationText:
        (_ plot: Plot, _ index: Int, _ text: String) -> () = { _, _, _ in }
    
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
    
    private lazy var equationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SandboxEquationCell.self)
        tableView.register(SandboxAddPlotCell.self)
        tableView.register(PlotParameterCell.self)
        tableView.backgroundColor = Color.grayBackground()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView(frame: CGRect(height: 16))
        tableView.allowsSelection = false
        tableView.layer.cornerRadius = 5
        tableView.dataSource = self
        tableView.delegate = self
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
    
    // MARK: Constaints
    
    private var tableViewTopToSuperviewBottomConstraint: NSLayoutConstraint?
    private var bottomStackViewBottomToTableViewTopConstaint: NSLayoutConstraint?
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        shouldPresentNavigationBar = false
        setupGestureRecognizers()
    }
    
    override func setupUIAfterLayoutSubviews() {
        super.setupUIAfterLayoutSubviews()
        equationsTableView.tableFooterView =
            UIView(frame: CGRect(height: equationsTableView.frame.height))
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
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-34)
        }
        bottomStackViewBottomToTableViewTopConstaint = bottomButtonStackView
            .bottomAnchor.constraint(
                equalTo: equationsTableView.topAnchor,
                constant: -WindowSafeArea.insets.bottom - 10)
        bottomStackViewBottomToTableViewTopConstaint?.isActive = true
        
        equationsTableView.snp.makeConstraints {
            $0.height.equalTo(
                -tableViewVissibleOffset + WindowSafeArea.insets.bottom
                + equationsTableView.layer.cornerRadius)
            $0.width.centerX.equalToSuperview()
        }
        tableViewTopToSuperviewBottomConstraint = equationsTableView.topAnchor
            .constraint(equalTo: view.bottomAnchor, constant: 0)
        tableViewTopToSuperviewBottomConstraint?.isActive = true
        
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
                        self.bottomStackViewBottomToTableViewTopConstaint?
                            .constant = isHidden ?
                                (-WindowSafeArea.insets.bottom - 10) : 0
                        self.tableViewTopToSuperviewBottomConstraint?.constant =
                            isHidden ? 0 : self.tableViewVissibleOffset
                        self.view.layoutSubviews()
                        self.setOpenHidePlotButtonDirection(
                            isHidden ? .up : .down)
                })
                if isHidden {
                    self.equationsTableView
                        .setContentOffset(.zero, animated: true)
                    self.equationsTableView.endEditing(true)
                }
            })
            .disposed(by: bag)
        
        isColorPickerHiddenSubject
            .subscribe(onNext: { isHidden in
                UIView.animate(withDuration: 0.2) {
                    self.plotColorPicker.alpha = isHidden ? 0 : 1
                }
            })
            .disposed(by: bag)
        
        RxKeyboard.instance
            .visibleHeight
            .drive(onNext: { self.shiftTableViewIfNeeded(keyboardHeight: $0) })
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
        isColorPickerHidden = true
        equationsTableView.endEditing(true)
    }
    
    
    // MARK: - API Methods
    
    func addPlot(_ plot: Plot) {
        plotsList.append(plot)
        
        equationsTableView.reloadData()
        plotScene.add(plot)
    }
    
    func removePlot(at index: Int) {
        plotsList.remove(at: index)
        
        self.equationsTableView.performBatchUpdates({
            let sectionsToDelete = [
                getPlotCellSection(from: index),
                getParametersCellsSection(from: index)
            ]
            self.equationsTableView.deleteSections(sectionsToDelete)
            self.equationsTableView.reloadData()
        })
        
        plotScene.deletePlot(at: index)
    }
    
    func setPlotList(_ list: [Plot]) {
        plotsList = list
        plotScene.deleteAll()
        
        plotsList.forEach { plotScene.add($0) }
        equationsTableView.reloadData()
    }
    
    func updateParametersOfPlot(at index: Int) {
        let section = index + 1
        equationsTableView.reloadSection(section)
    }
    
    
    // MARK: - Other Methods
    
    private enum ButtonDirection { case up, down }
    private func setOpenHidePlotButtonDirection(_ direction: ButtonDirection) {
        openHidePlotEditorButton.transform =
            CGAffineTransform(rotationAngle: direction == .up ? 0 : .pi)
    }
    
    private func prepare(_ cell: SandboxEquationCell, at indexPath: IndexPath,
                         with item: Plot) {
        let plotIndex = getPlotIndex(from: indexPath)
        
        SandboxEquationCellConfigurator(cell: cell)
            .configure(with: (plotIndex + 1, item))
        cell.didTapPlotImageButton = {
            self.didTapShowPlot(item.isHidden, plotIndex)
            self.isColorPickerHidden = true
        }
        cell.didLongPressPlotImageButton = {
            self.colorPickerRowTargetIndex = plotIndex
            self.isColorPickerHidden = false
            self.moveColorPickerToCell(at: plotIndex)
        }
        cell.didChangeEquationText = { text in
            self.didChangeEquationText(item, plotIndex, text)
        }
        cell.didBeginEquationTextEditing = {
            let section = self.getPlotCellSection(from: plotIndex)
            self.equationsTableView.scroll(section: section)
            self.triggeredKeyboardCellIndexPath = indexPath
        }
        
    }
    
    private func prepare(_ cell: PlotParameterCell,
                         with parameter: EquationParameter,
                         at indexPath: IndexPath) {
        PlotParameterCellConfigurator(cell: cell).configure(with: parameter)
        cell.didBeginEditingText = { _ in
            self.equationsTableView
                .scrollToRow(at: indexPath, at: .top, animated: true)
            self.triggeredKeyboardCellIndexPath = indexPath
        }
    }
    
    private func moveColorPickerToCell(at index: Int) {
        let rect = self.equationsTableView
            .rectForRow(at: IndexPath(section: index))
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
    
    private func isLastSection(_ section: Int) -> Bool {
        section == numberOfSections(in: equationsTableView) - 1
    }
    
    private func isEquationSection(_ section: Int) -> Bool {
        section.isMultiple(of: 2) && !isLastSection(section)
    }
    
    private func getPlotIndex(from section: Int) -> Int {
        section / 2
    }
    
    private func getPlotIndex(from indexPath: IndexPath) -> Int {
        getPlotIndex(from: indexPath.section)
    }
    
    private func getPlotCellSection(from plotIndex: Int) -> Int {
        plotIndex * 2
    }
    
    private func getParametersCellsSection(from plotIndex: Int) -> Int {
        plotIndex * 2 + 1
    }

    
    private func shiftTableViewIfNeeded(keyboardHeight: CGFloat) {
        guard !isEquationTableHidden else {
            return
        }
        
        var tableViewOffset = tableViewVissibleOffset
        if keyboardHeight == 0 {
            triggeredKeyboardCellIndexPath = nil
        } else if let indexPath = triggeredKeyboardCellIndexPath,
            let cell = equationsTableView.cellForRow(at: indexPath) {
            
            let cellHeight = cell.frame.height
            let vissibleTableHeight =
                view.frame.height - equationsTableView.frame.minY
            
            let spaceForCell = vissibleTableHeight - keyboardHeight
            if spaceForCell < cellHeight {
                tableViewOffset =
                    tableViewVissibleOffset - (cellHeight - spaceForCell)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.tableViewTopToSuperviewBottomConstraint?.constant =
                tableViewOffset
            self.view.layoutSubviews()
        }
    }
}


// MARK: - UITableViewDataSource

extension SandboxVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        plotsList.count * 2 + 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if isLastSection(section) {
            return 1
        } else {
            let plotIndex = getPlotIndex(from: section)
            let plot = plotsList[plotIndex]
            return isEquationSection(section) ? 1 : plot.equation.parameters.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !isLastSection(indexPath.section) else {
            let cell = tableView
                .dequeue(SandboxAddPlotCell.self, for: indexPath) ??
                SandboxAddPlotCell()
            cell.didTap = didTapAddPlot
            return cell
        }
        
        let plotIndex = getPlotIndex(from: indexPath)
        let plot = plotsList[plotIndex]

        if isEquationSection(indexPath.section) {
            let cell = tableView
                .dequeue(SandboxEquationCell.self, for: indexPath) ??
                SandboxEquationCell()
            self.prepare(cell, at: indexPath, with: plot)
            return cell
        } else {
            let parameter = plot.equation.parameters[indexPath.row]
            let cell = tableView
                .dequeue(PlotParameterCell.self, for: indexPath) ??
                PlotParameterCell()
            prepare(cell, with: parameter, at: indexPath)
            return cell
        }
    }
}


// MARK: - UITableViewDelegate

extension SandboxVC: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            guard isEquationSection(indexPath.section) else {
                return UISwipeActionsConfiguration(actions: [])
            }
            let deleteAction = UIContextualAction(
                style: .destructive, title: "Delete") { (_, _, _) in
                    let plotIndex = self.getPlotIndex(from: indexPath)
                    self.didTapDeleteEquation(plotIndex)
            }
            deleteAction.backgroundColor = Color.turquoise()
            return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
