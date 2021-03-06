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
import AVFoundation


protocol SandboxVCProtocol: UIViewController {
    var didTakePhoto: (_ image: UIImage) -> () { get set }
    var didTapSettingsButton: () -> () { get set }
    var didTapRecognizeButton: () -> () { get set }
    var didTapAddPlot: () -> () { get set }
    var didTapAddEquationFromSaved: () -> () { get set }
    var didTapChangeMode: (_ mode: PlotPresentationMode) -> () { get set }
    var didTapShowPlot: (_ show: Bool, _ index: Int) -> () { get set }
    var didSelectColorForPlot: (_ color: UIColor, _ index: Int) -> () { get set }
    var didChangeEquationText: (_ plot: Plot, _ index: Int, _ text: String) -> () { get set }
    var didTapDeleteEquation: (_ index: Int) -> () { get set }
    var didTapBack: () -> () { get set }
    var didTapSaveEquationAt: (_ index: Int) -> () { get set }
    var isEquationTableHidden: Bool { get set }
    func addPlot(_ plot: Plot)
    func removePlot(at index: Int)
    func setPlotList(_ list: [Plot])
    func updateParametersOfPlot(at index: Int)
    func setPresentationMode(_ mode: PlotPresentationMode)
    func performPhotoSavedAnimationAndSound()
}


class SandboxVC: BaseVC, SandboxVCProtocol {
    
    
    // MARK: - Properties
    
    private var plotsList: [Plot] = []
    
    private let isEquationTableHiddenSubject =
        BehaviorSubject<Bool>(value: true)
    var isEquationTableHidden: Bool {
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
    
    private let isSettingsHiddenSubject =
        BehaviorSubject<Bool>(value: true)
    private var isSettingsHidden: Bool {
        get { try! isSettingsHiddenSubject.value() }
        set { isSettingsHiddenSubject.onNext(newValue) }
    }
    
    private let plotScenes = [PlotScene(), PlotScene()]
    
    
    /// Index of row that caused appearing of `plotColorPicker`
    private var colorPickerRowTargetIndex: Int?
    
    /// IndexPath of cell that caused appearing of keyboard
    private var triggeredKeyboardCellIndexPath: IndexPath?
    
    private var tableViewOffsetCausedKeyboard: Observable<CGFloat> {
        RxKeyboard.instance
            .visibleHeight
            .asObservable()
            .map { keyboardHeight in
                if keyboardHeight == 0 {
                    self.triggeredKeyboardCellIndexPath = nil
                    return 0
                } else if let indexPath = self.triggeredKeyboardCellIndexPath,
                    let cell = self.equationsTableView.cellForRow(at: indexPath) {
                    
                    let cellHeight = cell.frame.height
                    let vissibleTableHeight =
                        self.view.frame.height - self.equationsTableView.frame.minY
                    
                    let spaceForCell = vissibleTableHeight - keyboardHeight
                    if spaceForCell < cellHeight {
                        return (cellHeight - spaceForCell)
                    } else {
                        return 0
                    }
                } else {
                    return 0
                }
        }
    }
    
    private(set) var mode: PlotPresentationMode = .vr
    
    
    // MARK: - Callbacks
    
    var didTapHomeButton: () -> () = { }
    var didTapSettingsButton: () -> () = { }
    var didTakePhoto: (_ image: UIImage) -> () = { _ in }
    var didTapChangeMode: (_ mode: PlotPresentationMode) -> () = { _ in }
    var didTapShowPlot: (_ show: Bool, _ index: Int) -> () = { _, _ in }
    var didSelectColorForPlot: (_ color: UIColor, _ index: Int) -> () = { _, _ in }
    var didTapDeleteEquation: (_ index: Int) -> () = { _ in }
    var didTapBack: () -> () = {}
    var didTapAddPlot: () -> () = {}
    var didChangeEquationText:
        (_ plot: Plot, _ index: Int, _ text: String) -> () = { _, _, _ in }
    var didTapRecognizeButton: () -> () = {}
    var didTapSaveEquationAt: (_ index: Int) -> () = { _ in }
    var didTapAddEquationFromSaved: () -> () = { }
    
    // MARK: Views
    
    private lazy var scnPlotView = PlotView(scene: plotScenes[0])
    private lazy var arscnPlotView = ARPlotView(scene: plotScenes[1])
    
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
        button.rx.tap.subscribe(onNext: { _ in self.saveScreenshot() })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.settings())
        button.rx.tap
            .subscribe(onNext: {
                _ in self.didTapSettingsButton()
                self.isSettingsHidden = !self.isSettingsHidden
            })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.home())
        button.tintColor = Color.inverseText()
        button.rx.tap.subscribe(onNext: {
            _ in self.didTapHomeButton()
            self.plotScenes.forEach {
                $0.resetNodeScale()
                $0.resetRotation()
                $0.resetRootPosition()
                $0.resetBounds()
            }
        })
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
    
    private lazy var manipulationModeSwitchButton: UIButton = {
        let button = UIButton()
        button.tintColor = Color.inverseText()
        button.setImage(Image.cube3D(), for: .normal)
        button.rx.tap
            .subscribe(onNext: { _ in
                self.gestureHandlerView.switchManipulationMode()
            })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var xyzControl: XYZControl = {
        let control = XYZControl()
        control.axisesSelection = (true, true, true)
        control.snp.makeConstraints { $0.size.equalTo(84) }
        control.rx.axises
            .subscribe(onNext: {
                self.gestureHandlerView.shouldHandleAxis = $0
            })
            .disposed(by: bag)
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
        }
        return plotColorPicker
    }()
    
    private(set) lazy var gestureHandlerView: PlotGestureHandlerView = {
        let view = PlotGestureHandlerView()
        view.addScene(plotScenes[0], panMovingMode: .absolute)
        view.addScene(plotScenes[1], panMovingMode: .relative)
        view.didTap = { self.arscnPlotView.placeNode() }
        return view
    }()
    
    private lazy var photoSavedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.icn_tick_main_share()
        imageView.alpha = 0
        return imageView
    }()
    
    private lazy var recognizeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.recognition())
        button.rx.tap
            .subscribe(onNext: { _ in
                let title = "Take a clear picture of the equation you want to be" +
                    " recognized"
                self.presentOkAlert(title: title,
                                    completion: self.didTapRecognizeButton)
            })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var dragRotateButton: UIButton = {
        let button = UIButton()
        button.rx.tap
            .subscribe(onNext: {
                self.gestureHandlerView.switchDragRotateMode()
            })
            .disposed(by: bag)
        return button
    }()
    
    
    // MARK: Settings Views
    
    private lazy var settingsContainerView = UIView()
    private lazy var settingsBackgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.settingsBubble()
        return imageView
    }()
    private lazy var arModeSettingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }()
    private lazy var arModeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = "AR mode"
            .withFont(Font.sfProDisplayRegular(size: 18)!)
            .withTextColor(.black)
        return label
    }()
    private lazy var presentationModeSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.onTintColor = Color.turquoise()
        switchControl.rx.isOn
            .subscribe(onNext: { isOn in
                self.didTapChangeMode(isOn ? .ar : .vr)
            })
            .disposed(by: bag)
        return switchControl
    }()
    
    
    
    // MARK: Constaints
    
    private var tableViewTopToSuperviewBottomConstraint: NSLayoutConstraint?
    private var bottomStackViewBottomToTableViewTopConstaint: NSLayoutConstraint?
    
    
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startARSession()
    }
    
    
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
        view.addSubviews(
            scnPlotView,
            arscnPlotView,
            gestureHandlerView,
            photoSavedImageView,
            buttonBack, topRightButtonStackView,
            bottomButtonStackView,
            equationsTableView,
            plotColorPicker,
            settingsContainerView,
            dragRotateButton
        )
        topRightButtonStackView.addArrangedSubviews([
            takePhotoButton,
            settingsButton,
            homeButton,
            recognizeButton,
        ])
        bottomButtonStackView.addArrangedSubviews([
            manipulationModeSwitchButton, xyzControl, openHidePlotEditorButton
        ])
        settingsContainerView.addSubviews(
            settingsBackgroundView,
            arModeSettingsStackView
        )
        arModeSettingsStackView.addArrangedSubviews(
            arModeLabel, presentationModeSwitch
        )
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        scnPlotView.snp.makeConstraints { $0.edges.equalToSuperview() }
        arscnPlotView.snp.makeConstraints { $0.edges.equalToSuperview() }
        gestureHandlerView.snp.makeConstraints { $0.edges.equalToSuperview() }
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
        settingsContainerView.snp.makeConstraints {
            $0.centerY.equalTo(settingsButton.snp.centerY)
            $0.trailing.equalTo(settingsButton.snp.leading).offset(4)
            $0.width.equalTo(236)
            $0.height.equalTo(60)
        }
        settingsBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        arModeSettingsStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14.5)
            $0.trailing.equalToSuperview().offset(-23)
        }
        photoSavedImageView.snp.makeConstraints {
            $0.edges.equalTo(takePhotoButton.snp.edges)
        }
        dragRotateButton.snp.makeConstraints {
            $0.centerX.equalTo(manipulationModeSwitchButton.snp.centerX)
            $0.bottom.equalTo(manipulationModeSwitchButton.snp.top).offset(-20)
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        Observable.combineLatest(
            isEquationTableHiddenSubject, tableViewOffsetCausedKeyboard)
            .subscribe(onNext: { isHidden, tableViewOffsetCausedKeyboard in
                UIView.animate(
                    withDuration: self.didAppear ? 0.2 : 0, delay: 0,
                    options: [.curveEaseOut], animations: {
                        self.bottomStackViewBottomToTableViewTopConstaint?
                            .constant = isHidden ?
                                (-WindowSafeArea.insets.bottom - 10) : 0
                        self.tableViewTopToSuperviewBottomConstraint?.constant =
                            isHidden ? 0 : self.tableViewVissibleOffset - tableViewOffsetCausedKeyboard
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
        
        gestureHandlerView.rx.manipulationMode
            .subscribe(onNext: {
                let image = $0 == .local ? Image.cube3DDotted() : Image.cube3D()
                self.manipulationModeSwitchButton
                    .setImage(image, animated: true)
            })
            .disposed(by: bag)
        
        gestureHandlerView.rx.dragRotateMode
            .subscribe(onNext: {
                let image = $0 == .drag ? Image.drag() : Image.rotate()
                self.dragRotateButton.setImage(image, animated: true)
            })
            .disposed(by: bag)
        
        isSettingsHiddenSubject
            .subscribe(onNext: { isHidden in
                UIView.animate(withDuration: 0.2) {
                    self.settingsContainerView.alpha = isHidden ? 0 : 1
                }
            })
            .disposed(by: bag)
    }
    
    private func setupGestureRecognizers() {
        view.rx
            .panGesture()
            .when(.began)
            .subscribe(onNext: { _ in
                self.isColorPickerHidden = true
                self.isSettingsHidden = true
            })
            .disposed(by: bag)
        view.rx.tapGesture()
            .subscribe(onNext: { _ in self.view.endEditing(true) })
            .disposed(by: bag)
        equationsTableView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.isColorPickerHidden = true
                self.isSettingsHidden = true
            })
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
        plotScenes.forEach { $0.add(plot) }
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
        
        plotScenes.forEach { $0.deletePlot(at: index) }
    }
    
    func setPlotList(_ list: [Plot]) {
        plotsList = list
        plotScenes.forEach { $0.deleteAll() }
        
        plotsList.forEach { plot in
            plotScenes.forEach {
                scene in scene.add(plot)
            }
        }
        equationsTableView.reloadData()
    }
    
    func updateParametersOfPlot(at index: Int) {
        let section = getParametersCellsSection(from: index)
        equationsTableView.reloadSection(section)
    }
    
    func setPresentationMode(_ mode: PlotPresentationMode) {
        self.mode = mode
        switch mode {
        case .vr:
            pauseARSession()
            arscnPlotView.isHidden = true
        case .ar:
            startARSession()
            arscnPlotView.startOrResetScan()
            arscnPlotView.isHidden = false
        }
    }
    
    func performPhotoSavedAnimationAndSound() {
        AudioServicesPlaySystemSound(1108)
        performCameraButtonAnimation()
        performDoneImageAnimation()
    }
    
    // MARK: - Other Methods
    
    private func saveScreenshot() {
        let image: UIImage
        switch mode {
        case .vr:
            image = scnPlotView.snapshot()
        case .ar:
            image = arscnPlotView.snapshot()
        }
        didTakePhoto(image)
    }
    
    private func performCameraButtonAnimation() {
        takePhotoButton.isEnabled = false
        // scale changes order:
        // 120ms:   changes form 100% to 60%
        // 1360ms:  static 60%
        // 160ms:   changes from 60% to 100%
        takePhotoButton.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.120, animations: {
            self.takePhotoButton.transform =
                CGAffineTransform(scaleX: 0.6, y: 0.6)
        }) { (success) in
            UIView.animate(withDuration: 0.160, delay: 1.360, animations: {
                self.takePhotoButton.transform = CGAffineTransform.identity
            })
        }
        
        // opacity changes order:
        // 80ms:    static 100%
        // 40ms:    changes from 100% to 0%
        // 1400ms:  static 0%
        // 40ms:    changes from 0% to 100%
        takePhotoButton.alpha = 1
        UIView.animate(withDuration: 0.04, delay: 0.08, animations: {
            self.takePhotoButton.alpha = 0
        }) { (success) in
            UIView.animate(withDuration: 0.04, delay: 1.4, animations: {
                self.takePhotoButton.alpha = 1
            }, completion: { (success) in
                self.takePhotoButton.isEnabled = true
            })
        }
    }
    
    private func performDoneImageAnimation() {
        // scale changes order:
        // 80ms:    static 60%
        // 200ms:   changes from 60% to 100%
        // 1040ms:  static 100%
        // 200ms:   changes from 100% to 60%
        photoSavedImageView.transform =
            CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.2, delay: 0.08, animations: {
            self.photoSavedImageView.transform = CGAffineTransform.identity
        }, completion: { (success) in
            UIView.animate(withDuration: 0.2, delay: 1.04, animations: {
                self.photoSavedImageView.transform =
                    CGAffineTransform(scaleX: 0.6, y: 0.6)
            })
        })
        
        // opacity changes order:
        // 80ms:    static 0%
        // 40ms:    changes from 0% to 100%
        // 1400ms:  static 100%
        // 40ms:    changes from 100% to 0%
        photoSavedImageView.alpha = 0
        UIView.animate(withDuration: 0.04, delay: 0.08, animations: {
            self.photoSavedImageView.alpha = 1
        }, completion: { (success) in
            UIView.animate(withDuration: 0.04, delay: 1.4, animations: {
                self.photoSavedImageView.alpha = 0
            })
        })
    }
    
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
            self.moveColorPickerToCell(at: indexPath)
        }
        cell.didChangeEquationText = { text in
            self.didChangeEquationText(item, plotIndex, text)
        }
        cell.didBeginEquationTextEditing = {
            let section = self.getPlotCellSection(from: plotIndex)
            self.equationsTableView.scroll(section: section)
            self.triggeredKeyboardCellIndexPath = indexPath
        }
        cell.didTapSaveEquation = {
            let index = self.getPlotIndex(from: indexPath)
            self.didTapSaveEquationAt(index)
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
    
    private func moveColorPickerToCell(at indexPath: IndexPath) {
        let rect = equationsTableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = equationsTableView.convert(rect, to: view)
        let absoluteYCellMiddle = rectOfCellInSuperview.midY
        
        var colorPickerYOffset =
            absoluteYCellMiddle - plotColorPicker.frame.height / 2
        
        let minPickerOffset = equationsTableView.frame.minY + rect.height / 2
            - plotColorPicker.frame.height / 2
        let maxPickerOffset =
            view.frame.height - plotColorPicker.frame.height
                - WindowSafeArea.insets.bottom - 5
        
        
        if colorPickerYOffset > maxPickerOffset {
            colorPickerYOffset = maxPickerOffset
            
            let targetPosition =
                colorPickerYOffset + plotColorPicker.frame.height / 2
            let targetPositionInTable = self.view
                .convert(CGPoint(x: 0, y: targetPosition),
                         to: equationsTableView).y
            let startCellPosition = rect.midY
            
            let scrollOffset = startCellPosition - targetPositionInTable
                + equationsTableView.contentOffset.y
            equationsTableView.setContentOffset(CGPoint(x: 0, y: scrollOffset),
                                                animated: true)
        } else if colorPickerYOffset < minPickerOffset {
            colorPickerYOffset = minPickerOffset
            equationsTableView.scrollToRow(at: indexPath,
                                           at: .top, animated: true)
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
    
    /// - Parameter plotIndex: index of plot
    /// - Returns: section of plot
    private func getPlotCellSection(from plotIndex: Int) -> Int {
        plotIndex * 2
    }
    
    private func getParametersCellsSection(from plotIndex: Int) -> Int {
        plotIndex * 2 + 1
    }
    
    private func startARSession() {
        arscnPlotView.run()
    }
    
    private func pauseARSession() {
        arscnPlotView.pause()
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
            cell.didLongPress = didTapAddEquationFromSaved
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
            guard isEquationSection(indexPath.section),
                let cell = tableView.cellForRow(at: indexPath)
                    as? SandboxEquationCell
                else {
                return UISwipeActionsConfiguration(actions: [])
            }
            let plotIndex = self.getPlotIndex(from: indexPath)
            let saveAction = UIContextualAction(
            style: .normal, title: "Save") { (_, _, _) in
                cell.performSavedAnimation()
                self.didTapSaveEquationAt(plotIndex)
            }
            saveAction.backgroundColor = Color.turquoise()
            let deleteAction = UIContextualAction(
            style: .destructive, title: "Delete") { _, _, _ in
                self.didTapDeleteEquation(plotIndex)
            }
            
            let plot = plotsList[plotIndex]
            let actions =
                plot.error == nil ? [deleteAction, saveAction] : [deleteAction]
            return UISwipeActionsConfiguration(actions: actions)
    }
}
