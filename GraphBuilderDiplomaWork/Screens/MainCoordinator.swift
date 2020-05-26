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
        
        pushSandbox()
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
        let vm = SandboxVM()
        vm.finishCompletion = { self.navVC.popViewController(animated: true) }
        let vc = SandboxVC()
        let dataBinder = SandboxDataBinder(viewModel: vm, views: [vc])
        dataBinder.bind()
        
        vm.setPlotList([
//            Plot(title: "", equation: Equation(latex: "x^2+z^2"         ,   function: "(x^2)+(z^2)"  )),
            Plot(equation: "x^2+z^2", color: .green),
//            Plot(title: "", equation: Equation(equation: "sin(x)+cos(z)+a")),
//            Plot(title: "", equation: Equation(equation: "sin(x*cos(z))")),
//            Plot(title: "", equation: Equation(equation: "sin(x)+sin(z)")),
//            Plot(title: "", equation: Equation(equation: "cos(x)+cos(z)")),
//            Plot(title: "", equation: Equation(equation: "tan(x)+tan(z)")),
//
//            Plot(title: "", equation: Equation(latex: "sin(x^z)"    ,   function: { (x: Float, z: Float) in tgamma(pow(x,z) + 1) }    )),
//            Plot(title: "", equation: Equation(equation: "x^2+sqrt(z)")),
//            Plot(title: "", equation: Equation(equation: "x^5+z"      )),
//            Plot(title: "", equation: Equation(equation: "sin(x^z)"   )),
//            Plot(title: "", equation: Equation(equation: "x^2+sqrt(z)")),
//            Plot(title: "", equation: Equation(equation: "x^5+z"      )),
//            Plot(title: "", equation: Equation(equation: "sin(x^z)"   )),
//            Plot(title: "", equation: Equation(equation: "x^2+sqrt(z)")),
//            Plot(title: "", equation: Equation(equation: "x^5+z"      )),
//            Plot(title: "", equation: Equation(equation: "sin(x^z)"   )),
//            Plot(title: "", equation: Equation(equation: "x^2+sqrt(z)")),
//            Plot(title: "", equation: Equation(equation: "x^5+z"      )),
//            Plot(title: "", equation: Equation(equation: "sin(x^z)"   )),
        ])
        vm.didRequestPictureRecognitionVC = {
            self.pushImagePickerScreen { (image) in
                if let image = image {
                    vm.addPlot(fromImage: image)
                }
            }
        }
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
//        vm.setPlotList([
//            Plot(title: "Hello", equation: Equation(latex: "y=x^2+sqrt(z)", function: NSNull()),
//                 parameters: [.init(name: "a", value: -2),
//                              .init(name: "b", value: -4),
//                              .init(name: "c", value: 0),
//                              .init(name: "d", value: 10),]),
//            Plot(title: "Hello", equation: Equation(latex: "y=x^5", function: NSNull()),
//                 parameters: [.init(name: "w", value: 2),
//                              .init(name: "r", value: 5)]),
//            Plot(title: "Hello", equation: Equation(latex: "y=sin(x^z)", function: NSNull()),
//                 parameters: [.init(name: "a", value: -2),
//                              .init(name: "b", value: -4)]),
//        ])
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
