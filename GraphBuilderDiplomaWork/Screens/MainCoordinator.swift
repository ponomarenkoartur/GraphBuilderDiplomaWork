//
//  MainCoordinator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift
import UIKit


class MainCoordinator: BaseCoordinator {
    
    
    // MARK: - Properties
    
    private let bag = DisposeBag()
    
    
    // MARK: - API Methods
    
    
    override func start() {
        super.start()
        pushWelcomeScreen()
    }
    
    override func start(with option: DeepLinkOption?) {
        start()
    }
    
    
    // MARK: - Private Methods
    
    private func pushWelcomeScreen() {
        let vm = WelcomeVM()
        vm.finishCompletion = { reason in
            switch reason {
            case .didTapSandbox:
                self.pushSandbox()
            case .didTapTopics:
                self.pushTopics()
            }
        }
        navVC.push(vm.viewController)
    }
    
    private func pushTopics() {
        print("pushing topics")
    }
    
    private func pushSandbox() {
        print("pushing sandbox")
    }
    
}
