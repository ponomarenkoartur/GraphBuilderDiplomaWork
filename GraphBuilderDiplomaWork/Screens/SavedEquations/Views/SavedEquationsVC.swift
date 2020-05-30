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
    var didSelectEquationAt: (_ index: Int) -> () { get set }
    var didDeselectEquationAt: (_ index: Int) -> () { get set }
    var didTapConfirmSelection: () -> () { get set }
    func setEquations(_ equations: [SelectiveItem<Equation>])
    func setConfirmButtonEnabled(_ isEnabled: Bool)
}

class SavedEquationsVC: BaseVC, SavedEquationsVCProtocol {
    
    
    // MARK: - Properties
    
    var didTapDeleteEquationAt: (_ index: Int) -> () = { _ in }
    var didSelectEquationAt: (_ index: Int) -> () = { _ in }
    var didTapConfirmSelection: () -> () = {}
    var didDeselectEquationAt: (_ index: Int) -> () = { _ in }
    private let equationsSubject =
        BehaviorSubject<[SelectiveItem<Equation>]>(value: [])
    
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SavedEquationsCell.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        
        equationsSubject.bind(to: tableView.rx.items) {
            (tableView: UITableView, index: Int,
            equation: SelectiveItem<Equation>)
            -> UITableViewCell in
            let cell = tableView.dequeue(SavedEquationsCell.self, for: index)
                ?? SavedEquationsCell()
            let configurator = SavedEquationsCellConfigurator(cell: cell)
            configurator.configure(with: (index + 1, equation.item))
            if equation.isSelected {
                tableView.selectRow(at: IndexPath(row: index), animated: true,
                                    scrollPosition: .none)
            }
            return cell
        }.disposed(by: bag)
        return tableView
    }()
    
    private lazy var confirmSelectionButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Confirm", style: .done,
                                     target: nil, action: nil)
        button.rx.tap.subscribe(onNext: self.didTapConfirmSelection)
            .disposed(by: bag)
        button.tintColor = Color.turquoise()
        return button
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        navigationItem.rightBarButtonItem = confirmSelectionButton
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
    
    func setEquations(_ equations: [SelectiveItem<Equation>]) {
        equationsSubject.onNext(equations)
    }
    
    func setConfirmButtonEnabled(_ isEnabled: Bool) {
        confirmSelectionButton.isEnabled = isEnabled
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
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        didSelectEquationAt(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath) {
        didDeselectEquationAt(indexPath.row)
    }
}
