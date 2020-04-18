//
//  TopicsListVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class TopicsListVC: BaseVC {
    
    
    // MARK: - Properties
    
    var menuItems: [String]? {
        didSet {
//            Observable.of(menuItems ?? []).bind(to: tableView.rx.items) {
//                (tableView: UITableView, index: Int, element: String) in
//                let cell =
//                    tableView.dequeue(WelcomeScreenMenuCell.self, for: index) ??
//                    WelcomeScreenMenuCell()
//                cell.labelText = element
//                cell.labelTextColor = index.isMultiple(of: 2) ?
//                    Color.defaultText() : Color.turquoise()
//                return cell
//            }.disposed(by: bag)
        }
    }
    
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 89
        return tableView
    }()
    

    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        title = "Topics"
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews([
            tableView
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
    }
}
