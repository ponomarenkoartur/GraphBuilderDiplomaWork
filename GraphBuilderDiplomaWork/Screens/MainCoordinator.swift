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
    private var imagePickerCompletion: (_ image: UIImage) -> () = { _ in }
    
    
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
        let vc = WelcomeVC()
        let dataBinder = WelcomeScreenDataBinder(viewModel: vm, views: [vc])
        dataBinder.bind()
        
        vm.finishCompletion = { reason in
            switch reason {
            case .didTapSandbox:
                self.pushSandbox()
            case .didTapTopics:
                self.pushTopicsList()
            case .didTapSavedEquations:
                self.pushSavedEquations { selectedEquations in
                    self.pushSandbox(with: selectedEquations)
                }
            }
        }
        navVC.push(vc)
    }
    
    private func pushTopicsList() {
        let vm = TopicsListVM()
        let vc = TopicsListVC()
        let dataBinder = TopicsListDataBinder(viewModel: vm, views: [vc])
        dataBinder.bind()
        
        vm.finishCompletion = { reason in
            if case .didSelectTopic(_, let position) = reason {
                self.pushTopicsContainer(vm.topics, selectedTopicIndex: position)
            }
        }
        navVC.push(vc)
    }
    
    private func pushSandbox(with equations: [Equation] = []) {
        let vm = SandboxVM()
        let vc = SandboxVC()
        let dataBinder = SandboxDataBinder(viewModel: vm, views: [vc])
        dataBinder.bind()
        
        vm.finishCompletion = { self.navVC.popViewController(animated: true) }
        vm.setPlotList(equations.map { Plot(equation: $0) })
        vm.didRequireAddingEquationFromSaved = {
            self.pushSavedEquations { selectedEquations in
                self.navVC.popViewController(animated: true)
                selectedEquations.forEach { vm.addPlot(Plot(equation: $0)) }
            }
        }
        
//        vm.setPlotList([
//            Plot(equation: "x^2+z^2", color: .green),
//            Plot(equation: "sin(x)+cos(z)+a"),
//            Plot(equation: "sin(x*cos(z))"),
//            Plot(equation: "sin(x)+sin(z)"),
//            Plot(equation: "cos(x)+cos(z)"),
//            Plot(equation: "tan(x)+tan(z)"),
//            Plot(equation: "x^2+sqrt(z)"),
//            Plot(equation: "x^5+z"      ),
//            Plot(equation: "sin(x^z)"   ),
//            Plot(equation: "x^2+sqrt(z)"),
//            Plot(equation: "x^5+z"      ),
//            Plot(equation: "sin(x^z)"   ),
//            Plot(equation: "x^2+sqrt(z)"),
//            Plot(equation: "x^5+z"      ),
//            Plot(equation: "sin(x^z)"   ),
//            Plot(equation: "x^2+sqrt(z)"),
//            Plot(equation: "x^5+z"      ),
//            Plot(equation: "sin(x^z)"   ),
//        ])
        vm.didRequestPictureRecognitionVC = {
            self.pushImagePickerScreen { (image) in
                if let image = image {
                    vm.addPlots(fromImage: image)
                }
            }
        }
        vm.finishCompletion = { _ in
            self.navVC.popViewController(animated: true)
        }
        navVC.push(vc)
    }

    private func pushTopic(_ topic: Topic, serialPosition: SerialPosition?) {
        let vm = TopicVM(topic: topic, position: serialPosition)
        let vc = TopicVC()
        let dataBinder = TopicScreenDataBinder(viewModel: vm, views: [vc])
        dataBinder.bind()
        
        navVC.push(vc)
    }
    
    private func pushTopicsContainer(_ topicsList: [Topic],
                                     selectedTopicIndex: Int) {
        let vm = TopicsContainerVM(topicsList: topicsList,
                                   selectedTopicIndex: selectedTopicIndex)
        let vc = TopicsContainerVC()
        let dataBinder = TopicsContainerDataBinder(viewModel: vm, views: [vc])
        dataBinder.bind()
        
        vm.finishCompletion = { reason in
            switch reason {
            case .didTapBuildPlotInSandbox(let item):
                self.pushSandbox(with: [Equation(equation: item.graph)])
            }
        }
        
        navVC.push(vc)
    }
    
    private func pushTopicPlots() {
        let vm = TopicPlotsVM()
        let vc = TopicPlotsVC()
        let dataBinder = TopicPlotsDataBinder(viewModel: vm, views: [vc])
        dataBinder.bind()
        navVC.push(vc)
    }
    
    private func pushTestScreen() {
        navVC.push(TestViewController())
    }
    
    private func pushImagePickerScreen(
        _ completion: @escaping (_ takenImage: UIImage?) -> ()) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePickerCompletion = completion
        navVC.present(imagePicker, animated: true)
    }
    
    private func pushSavedEquations(
        completion: @escaping (_ selectedEquations: [Equation]) -> ()) {
        let vm = SavedEquationsVM()
        let vc = SavedEquationsVC()
        let dataBinder = SavedEquationsDataBinder(viewModel: vm, views: [vc])
        dataBinder.bind()
        
        vm.finishCompletion = { reason in
            switch reason {
            case .didSelectEquations(let equations):
                completion(equations)
            }
        }
        
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


// MARK: - UIImagePickerControllerDelegate

extension MainCoordinator: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerCompletion(image)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
