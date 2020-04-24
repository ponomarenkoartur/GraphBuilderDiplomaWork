//
//  SandboxVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 24.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class SandboxVC: BaseVC {
    
    
    // MARK: - Properties
    
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
                UIView.animate(
                    withDuration: 0.3, delay: 0, options: [.curveEaseInOut],
                    animations: {
                    button.transform = button.transform.rotated(by: .pi)
                })
            })
            .disposed(by: bag)
        return button
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        shouldPresentNavigationBar = false
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews([
            arView, buttonBack, topRightButtonStackView, bottomButtonStackView
        ])
        topRightButtonStackView.addArrangedSubviews([
            takePhotoButton,
            settingsButton,
            homeButton,
            modeSwitch
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-34)
        }
    }
    
    
}
