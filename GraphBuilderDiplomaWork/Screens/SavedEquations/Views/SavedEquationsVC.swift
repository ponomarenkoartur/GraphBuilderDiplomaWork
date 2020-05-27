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
    var didTapDeleteEquationAt: (_ index: Int) -> () { get set }
    func setEquations(_ equations: [Equation])
}

class SavedEquationsVC: BaseVC, SavedEquationsVCProtocol {
    
    
    // MARK: - Properties
    
    var didTapDeleteEquationAt: (_ index: Int) -> () = { _ in }
    private let equationsSubject = BehaviorSubject<[Equation]>(value: [])
    
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SavedEquationsCell.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        
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
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        title = "Saved Equations"
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews(tableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    
    // MARK: - API Methods
    
    func setEquations(_ equations: [Equation]) {
        equationsSubject.onNext(equations)
    }
}


// MARK: - UITableViewDelegate

extension SavedEquationsVC: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(
            style: .destructive, title: "Delete") { (_, _, _) in
                self.didTapDeleteEquationAt(indexPath.row)
            }
            deleteAction.backgroundColor = Color.turquoise()
            return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
