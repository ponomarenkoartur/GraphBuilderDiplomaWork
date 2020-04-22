//
//  TopicFooterView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class TopicFooterView: BaseView {
    
    
    // MARK: - Enums
    
    enum Button {
        case previous, next
    }
    
    
    // MARK: - Properties
    
    var buttons: Set<Button> {
        didSet {
            containerStackView.arrangedSubviews.forEach {
                $0.removeFromSuperview()
            }
            
            if buttons.contains(.previous) {
                containerStackView.addArrangedSubview(prevTopicButton)
            }
            if buttons.contains(.next) {
                containerStackView.addArrangedSubview(nextTopicButton)
            }
        }
    }
    
    
    // MARK: Callback
    
    var didTapPreviousTopic: () -> () = {}
    var didTapNextTopic: () -> () = {}
    
    // MARK: Views
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var prevTopicButton: UIButton = {
        let button = self.createButton(title: "Previous topic")
        button.rx.tap
            .subscribe(onNext: { _ in self.didTapPreviousTopic() })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var nextTopicButton: UIButton = {
        let button = self.createButton(title: "Next topic")
        button.rx.tap
            .subscribe(onNext: { _ in self.didTapNextTopic() })
            .disposed(by: bag)
        return button
    }()
    
    
    
    // MARK: - Initialization
    
    init(buttons: Set<Button> = [.previous, .next]) {
        self.buttons = buttons
        super.init(frame: CGRect(height: 50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(containerStackView)
        containerStackView.addArrangedSubviews([
            prevTopicButton, nextTopicButton
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        containerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().offset(-20).priority(999)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.turquoise()
        
        let title = title.uppercased()
            .withFont(Font.sfProDisplayMedium(size: 15)!)
            .withTextColor(Color.inverseText()!)
        button.setAttributedTitle(title)
        
        button.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.width.greaterThanOrEqualTo(150)
        }
        
        return button
    }
    
}
