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
        navVC.push(vm.viewController!)
    }
    
    private func pushTopics() {
        let vm = TopicsListVM()
        vm.finishCompletion = { reason in
            if case .didSelectTopic(let topic, let position) = reason {
                self.pushTopic(topic, serialPosition: position)
            }
        }
        navVC.push(vm.viewController!)
    }
    
    private func pushSandbox() {
        print("pushing sandbox")
    }
    
    private func pushTopic(_ topic: Topic, serialPosition: SerialPosition?) {
        let vm = TopicVM(topic: topic, serialPosition: serialPosition)
        navVC.push(vm.viewController!)
    }
    
}


// MARK: - UINavigationControllerDelegate

extension MainCoordinator {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController, animated: Bool) {
        guard navigationController == navVC else { return }
        
        if let vc = viewController as? NavigationBarPresenter {
            navigationController.setNavigationBarHidden(
                !vc.shouldPresentNavigationBar, animated: true)
            navigationController.navigationBar.prefersLargeTitles =
                vc.shouldPreferLargeTitle
        }
    }
}
