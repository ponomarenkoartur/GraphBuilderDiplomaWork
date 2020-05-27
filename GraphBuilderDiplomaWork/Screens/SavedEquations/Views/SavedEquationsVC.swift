//
//  SavedEquationsVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 26.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


protocol SavedEquationsVCProtocol: UIViewController {
    func setEquations(_ equations: [Equation])
}

class SavedEquationsVC: BaseVC, SavedEquationsVCProtocol {
    
    
    // MARK: - Properties
    
    private let equationsSubject = BehaviorSubject<[Equation]>(value: [])
    
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SavedEquationsCell.self)
        
        equationsSubject.bind(to: tableView.rx.items) {
            (tableView: UITableView, index: Int, equation: Equation)
            -> UITableViewCell in
            let cell = tableView.dequeue(SavedEquationsCell.self, for: index)
                ?? SavedEquationsCell()
            let configurator = SavedEquationsCellConfigurator(cell: cell)
            configurator.configure(with: (index + 1, equation))
            return cell
        }.disposed(by: bag)
        return tableView
    }()
    
    
    // MARK: - API Methods
    
    func setEquations(_ equations: [Equation]) {
        equationsSubject.onNext(equations)
    }
}
