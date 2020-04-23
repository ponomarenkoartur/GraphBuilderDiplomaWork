//
//  NamedSwitchControl.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class NamedSwitchControl: BaseView {
    
    
    // MARK: - Enums
    
    enum Position {
        case left, right
        
        mutating func `switch`() {
            self = self.switched()
        }
        
        func switched() -> Position {
            self == .left ? .right : .left
        }
    }
    
    
    // MARK: - Constants
    
    // MARK: Sizes
    
    private let fixedHeight: CGFloat = 27.17
    private let fixedWidth: CGFloat = 50.64
    private let circleSideSize: CGFloat = 25.52
    private let circleLeftPositionOffset: CGFloat = 0.85
    private let circleRightPositionOffset: CGFloat = 24.29
    private let labelCenterYOffsetFromEdge: CGFloat = 12.485
    
    
    // MARK: Colors
    
    // Fill Colors
    private let leftBackgroundColor = #colorLiteral(red: 0.3137254902, green: 0.7176470588, blue: 1, alpha: 1)
    private let rightBackgroundColor = Color.background()
    private let circleColor = UIColor.white
    
    // Text Colors
    private let leftBackgroundTextColor = Color.inverseText()
    private let rightBackgroundTextColor = Color.defaultText()
    private let circleTextColor = UIColor.black
    
    // Other Colors
    private let borderColor = #colorLiteral(red: 0.6156862745, green: 0.6156862745, blue: 0.6156862745, alpha: 0.5)
    
    // MARK: Fonts
    
    private let backgroundTextFont = Font.sfProDisplayRegular(size: 11)
    private let textInCircleFont = Font.sfProDisplayBold(size: 11)
    
    
    
    // MARK: - Properties
    
    private var positionSubject = BehaviorSubject<Position>(value: .left)
    var position: Position { try! positionSubject.value() }
    
    private var leftTextSubject = BehaviorSubject<String>(value: "A")
    private var rightTextSubject = BehaviorSubject<String>(value: "B")
    var leftText: String {
        get { try! leftTextSubject.value() }
        set { leftTextSubject.onNext(newValue) }
    }
    var rightText: String {
        get { try! rightTextSubject.value() }
        set { rightTextSubject.onNext(newValue) }
    }
    
    var textOfSelectedPosition: String {
        position == .left ? leftText : rightText
    }
    
    // MARK: Views
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = leftBackgroundColor
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = fixedHeight / 2
        view.snp.makeConstraints {
            $0.height.equalTo(fixedHeight)
            $0.width.equalTo(fixedWidth)
        }
        return view
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = 0.5
        view.snp.makeConstraints { $0.size.equalTo(circleSideSize) }
        view.layer.cornerRadius = circleSideSize / 2
        return view
    }()
    
    private lazy var leftBackgroundLabel: UILabel = {
        let label = UILabel()
        label.font = backgroundTextFont
        return label
    }()
    
    private lazy var rightBackgroundLabel: UILabel = {
        let label = UILabel()
        label.font = backgroundTextFont
        return label
    }()
    
    private lazy var labelOnCircle: UILabel = {
        let label = UILabel()
        label.text = "AR"
        label.font = textInCircleFont
        return label
    }()
    
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !leftBackgroundLabel.constraints.isEmpty,
            !rightBackgroundLabel.constraints.isEmpty else { return }
        leftBackgroundLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(
                labelCenterYOffsetFromEdge -
                    (leftBackgroundLabel.frame.width / 2))
        }
        rightBackgroundLabel.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(
            (rightBackgroundLabel.frame.width / 2) - labelCenterYOffsetFromEdge)
        }
    }
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        addGestureRecognizers()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(backgroundView)
        backgroundView.addSubviews([
            leftBackgroundLabel, rightBackgroundLabel, circleView,
        ])
        circleView.addSubview(labelOnCircle)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        self.snp.makeConstraints {
            $0.height.equalTo(fixedHeight)
            $0.width.equalTo(fixedWidth)
        }
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        leftBackgroundLabel.layoutSubviews()
        leftBackgroundLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(
                labelCenterYOffsetFromEdge -
                    (leftBackgroundLabel.frame.width / 2))
        }
        rightBackgroundLabel.layoutSubviews()
        rightBackgroundLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(
                (rightBackgroundLabel.frame.width / 2) - labelCenterYOffsetFromEdge)
        }
        circleView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(circleLeftPositionOffset)
        }
        labelOnCircle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        Observable.combineLatest(
            positionSubject.asObservable(),
            leftTextSubject.asObservable(),
            rightTextSubject.asObservable())
                .subscribe(onNext: { position, leftText, rightText in
                    self.labelOnCircle.text = position == .left ?
                        leftText : rightText
                    self.leftBackgroundLabel.text = leftText
                    self.rightBackgroundLabel.text = rightText
                    self.layoutSubviews()
                })
                .disposed(by: bag)
        
        positionSubject.asObservable()
            .subscribe(onNext: { position in
                UIView.animate(withDuration: 0.1, animations: {
                    self.circleView.snp.updateConstraints {
                        $0.width.equalTo(self.circleSideSize * 1.5)
                    }
                    self.layoutIfNeeded()
                }, completion: { _ in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.circleView.snp.updateConstraints {
                            $0.width.equalTo(self.circleSideSize)
                        }
                        self.layoutIfNeeded()
                    })
                })
                UIView.animate(withDuration: 0.2) {
                    self.circleView.snp.updateConstraints {
                        $0.leading.equalToSuperview()
                            .offset(position == .left ?
                                self.circleLeftPositionOffset :
                                self.circleRightPositionOffset)
                    }
                    self.layoutIfNeeded()
                    self.backgroundView.backgroundColor = position == .left ?
                        self.leftBackgroundColor : self.rightBackgroundColor
                }
            })
            .disposed(by: bag)
    }
    
    
    // MARK: - Gestures
    
    private func addGestureRecognizers() {
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in self.switch() })
            .disposed(by: bag)
        self.rx.swipeGesture([.left, .right])
            .when(.recognized)
            .subscribe(onNext: {
                let direction = $0.direction
                if direction == .left {
                    self.setPosition(.left)
                } else if direction == .right {
                    self.setPosition(.right)
                }
            })
            .disposed(by: bag)
    }
     
    
    // MARK: - API Methods
    
    func setPosition(_ position: Position) {
        self.positionSubject.onNext(position)
    }
    
    func `switch`() {
        self.positionSubject.onNext(position.switched())
    }
}
