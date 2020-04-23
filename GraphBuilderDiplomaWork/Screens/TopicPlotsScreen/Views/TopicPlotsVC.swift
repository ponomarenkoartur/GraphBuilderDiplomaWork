//
//  TopicPlotsVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class TopicPlotsVC: BaseVC, TopicPlotsVCProtocol {
    
    
    // MARK: - Enums
    
    private enum CollectionAppearance {
        case hidden, short, full
    }
    
    private enum ViewAppearance {
        case details, fullscreen
    }
    
    
    // MARK: - Constants
    
    private lazy var collectionViewBottomOffset: [CollectionAppearance: CGFloat] = {[
        .full: -(view.frame.height / 3 * 2) - WindowSafeArea.insets.bottom,
        .hidden: 0 + WindowSafeArea.insets.bottom,
        .short: -67 - WindowSafeArea.insets.bottom
    ]}()
    
    
    // MARK: - Properties
    
    private var plotsList: [Plot] = []
    
    private let viewAppearanceSubject =
        BehaviorSubject<ViewAppearance>(value: .details)
    private var viewAppearance: ViewAppearance {
        get { try! viewAppearanceSubject.value() }
        set { viewAppearanceSubject.onNext(newValue) }
    }
    
    private let collectionAppearanceSubject =
        BehaviorSubject<CollectionAppearance>(value: .short)
    private var collectionAppearance: CollectionAppearance {
        get { try! collectionAppearanceSubject.value() }
        set { collectionAppearanceSubject.onNext(newValue) }
    }
    
    
    // MARK: Callbacks
    
    var didChangeSelectedPlotIndex: (_ index: Int) -> () = { _ in }
    var didTapPreviousPlotButton: () -> () = { }
    var didTapNextPlotButton: () -> () = { }
    var didTapHomeButton: () -> () = { }
    var didTapSettingsButton: () -> () = { }
    var didTapCameraButton: () -> () = { }
    var didTapChangeMode: (_ mode: PlotPresentationMode) -> () = { _ in }
    
    // MARK: Views
    
    private lazy var buttonsStackView: UIStackView = {
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
        button.tintColor = Color.inverseText()
        button.rx.tap.subscribe(onNext: { _ in self.didTapCameraButton() })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.settings())
        button.tintColor = Color.inverseText()
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
    
    private lazy var modeSwitch: NamedSwitchControl = {
        let modeSwitch = NamedSwitchControl()
        modeSwitch.leftText = "VR"
        modeSwitch.rightText = "AR"
        modeSwitch.layer.shadowOpacity = 1
        modeSwitch.layer.shadowColor = Color.defaultShadow()?.cgColor
        modeSwitch.layer.shadowRadius = 2
        modeSwitch.layer.shadowOffset = .zero
        modeSwitch.rx.position
            .subscribe(onNext: { position in
                self.didTapChangeMode(position == .left ? .vr : .ar)
            })
            .disposed(by: bag)
        
        return modeSwitch
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopicPlotInfoCell.self)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentOffset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never

        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        
        collectionView.rx
            .swipeGesture([.up, .down])
            .when(.recognized)
            .subscribe(onNext: { swipe in
                switch (swipe.direction, self.collectionAppearance) {
                case (.up, .short):
                    self.collectionAppearance = .full
                case (.down, .full):
                    self.collectionAppearance = .short
                default:
                    break
                }
            })
            .disposed(by: bag)

        return collectionView
    }()
    
    private lazy var plotView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in self.switchViewAppearance() })
            .disposed(by: bag)
        return view
    }()
    
    
    // MARK: - View Lifecycle
    
    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        modeSwitch.layer.shadowColor = Color.defaultShadow()?.cgColor
    }
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        shouldPreferLargeTitle = false
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews([plotView, buttonsStackView, collectionView])
        buttonsStackView.addArrangedSubviews([
            takePhotoButton, settingsButton, homeButton, modeSwitch
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        collectionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.top.equalTo(view.snp.bottom).offset(-100)
            $0.height.equalTo(-collectionViewBottomOffset[.full]!)
        }
        plotView.snp.makeConstraints { $0.edges.equalToSuperview() }
        buttonsStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalTo(-10)
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        collectionAppearanceSubject
            .subscribe(onNext: { appearance in
                UIView.animate(withDuration: self.didAppear ? 0.2 : 0) {
                    self.collectionView.snp.updateConstraints {
                        if let offset = self.collectionViewBottomOffset[appearance] {
                            $0.top.equalTo(self.view.snp.bottom).offset(offset)
                        }
                    }
                    self.view.layoutSubviews()
                }
            })
            .disposed(by: bag)
        
        viewAppearanceSubject
            .subscribe(onNext: { appearance in
                self.collectionAppearance =
                    appearance == .fullscreen ? .hidden : .short
                self.navigationController?
                    .setNavigationBarHidden(appearance == .fullscreen,
                                            animated: true)
                UIView.animate(withDuration: self.didAppear ? 0.2 : 0) {
                    self.buttonsStackView.snp.updateConstraints {
                        $0.trailing.equalTo(appearance == .details ? -10 : self.buttonsStackView.frame.width)
                    }
                    self.view.layoutSubviews()
                }
            })
            .disposed(by: bag)
    }
    
    
    // MARK: - API Methods
    
    func setPlotList(_ list: [Plot]) {
        plotsList = list
        collectionView.reloadData()
    }
    
    func setSelectedPlotIndex(_ index: Int) {
        collectionView.scrollIfNeeded(to: index)
    }
    
    // MARK: - Private Methods
    
    private func switchViewAppearance() {
        viewAppearance = viewAppearance == .details ? .fullscreen : .details
    }
}


// MARK: - UICollectionViewDataSource

extension TopicPlotsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        plotsList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView
            .dequeue(TopicPlotInfoCell.self, for: indexPath) ??
            TopicPlotInfoCell()
        prepare(cell, at: indexPath.row)
        
        return cell
    }
    
    private func prepare(_ cell: TopicPlotInfoCell, at index: Int) {
        guard let plot = plotsList[safe: index],
            let position = SerialPosition
                .get(forIndex: index, in: plotsList) else { return }
                                                
        TopicPlotInfoCellConfigurator(cell: cell)
            .configure(with: (position, plot))
        
        cell.didTapPreviousPlotButton = didTapPreviousPlotButton
        cell.didTapNextPlotButton = didTapNextPlotButton
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension TopicPlotsVC: UICollectionViewDelegate,
                        UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = -collectionViewBottomOffset[.full]!
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TopicsContainerCell else { return }
        cell.viewController.didMove(toParent: self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let page = collectionView.pageIndex {
            didChangeSelectedPlotIndex(page)
        }
    }
}
