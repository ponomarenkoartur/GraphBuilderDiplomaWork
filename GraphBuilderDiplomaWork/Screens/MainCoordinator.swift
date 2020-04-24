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
        
        self.pushSandbox()
        return;
        
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
                self.pushTopicsList()
            }
        }
        navVC.push(vm.viewController!)
    }
    
    private func pushTopicsList() {
        let vm = TopicsListVM()
        vm.finishCompletion = { reason in
            if case .didSelectTopic(_, let position) = reason {
                self.pushTopicsContainer(vm.topicsList, selectedTopicIndex: position)
            }
        }
        navVC.push(vm.viewController!)
    }
    
    private func pushSandbox() {
        let vc = SandboxVC()
        navVC.push(vc)
    }

    private func pushTopic(_ topic: Topic, serialPosition: SerialPosition?) {
        let vm = TopicVM(topic: topic, serialPosition: serialPosition)
        navVC.push(vm.viewController!)
    }
    
    private func pushTopicsContainer(_ topicsList: Observable<[Topic]>,
                                     selectedTopicIndex: Int) {
        let vm = TopicsContainerVM(topicsList: topicsList,
                                   selectedTopicIndex: selectedTopicIndex)
        navVC.push(vm.viewController!)
    }
    
    private func pushTopicPlots() {
        let vm = TopicPlotsVM()
        vm.setPlotList([
            Plot(title: "Hello", equation: "y=x^2+sqrt(z)",
                 parameters: [.init(name: "a", value: -2),
                              .init(name: "b", value: -4),
                              .init(name: "c", value: 0),
                              .init(name: "d", value: 10),]),
            Plot(title: "Hello", equation: "y=x^5",
                 parameters: [.init(name: "w", value: 2),
                              .init(name: "r", value: 5)]),
            Plot(title: "Hello", equation: "y=sin(x^z)",
                 parameters: [.init(name: "a", value: -2),
                              .init(name: "b", value: -4)]),
        ])
        let vc = TopicPlotsVC()
        let dataBinder = TopicPlotsDataBinder(viewModel: vm, views: [vc])
        dataBinder.bind()
        
        navVC.push(vc)
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
