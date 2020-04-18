//
//  BaseVC.swift
//  p138
//
//  Created by artur_ios on 15.01.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit
import RxGesture
import RxSwift
import RxKeyboard


class BaseVC: UIViewController, NavigationBarPresenter {
    
    
    // MARK: - Properties
    
    /// Keyboard won't hide if user tapped the view that contains this array
    var hideKeyboardWhenTappedAroundFilter: Set<UIView> = []
    var shouldHideKeyboardWhenTappedAround: Bool = true
    private var attachedToKeyboard:
        [(view: UIView, offset: CGFloat, animatesWithKeyboard: Bool)] = []
    var bag = DisposeBag()
    var shouldPresentNavigationBar = true
    var shouldPreferLargeTitle = true
    
    
    // MARK: - Initialization
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
        observeKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUIAfterLayoutSubviews()
    }
    
    
    /// Call 'addSubview' methods before caliing super.setupUI()
    /// in overrided methods
    func setupUI() {
        view.backgroundColor = Color.background()
        addSubviews()
        setupConstraints()
    }
    
    func setupUIAfterLayoutSubviews() {}
    
    func addSubviews() {}
    
    func setupConstraints() {}
    
    func setupBinding() {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard shouldHideKeyboardWhenTappedAround else { return }
        let touchedViews = Set(touches.compactMap { touch in
            view.hitTest(touch.location(in: view), with: event)
        })
        if !hideKeyboardWhenTappedAroundFilter.intersects(with: touchedViews),
            !touchedViews.contains(where: { $0 is UITextField }) {
            dismissKeyboard()
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    /// Create constraint to bottom of `view`
    /// that is equal to height of keyboard
    /// - Parameters:
    ///   - view: view that is attached to bottom
    ///   - offset: addition offset from bottom
    func attachToKeyboard(_ view: UIView, offset: CGFloat = 0,
                          animatesWithKeyboard: Bool = true) {
        view.snp.makeConstraints {
            $0.bottom.equalToSuperview()
                .offset(-WindowSafeArea.insets.bottom - offset)
        }
        attachedToKeyboard.append((view, offset, animatesWithKeyboard))
    }
    
    private func observeKeyboard() {
        RxKeyboard.instance
            .visibleHeight
            .drive(
                onNext: { [weak self] keyboardHeight in
                    guard let self = self else { return }
                    self.attachedToKeyboard.forEach {
                        view, offset, animatesWithKeyboard in
                        view.snp.updateConstraints {
                            $0.bottom.equalToSuperview()
                                .offset(keyboardHeight == 0 ?
                                    -(WindowSafeArea.insets.bottom + offset) :
                                    -(keyboardHeight + offset))
                        }
                        if animatesWithKeyboard {
                            view.superview?.layoutIfNeeded()
                        }
                    }
            })
            .disposed(by: bag)
    }
}
