//
//  TopicVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class TopicVC: BaseVC {

    
    // MARK: - Properties
    
    private let itemsSubject = BehaviorSubject<[Any]>(value: [])
    var items: Observable<[Any]>? { itemsSubject.asObservable() }
    
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TopicCell.self)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    

    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func setupBinding() {
        super.setupBinding()
        items?.bind(to: tableView.rx.items) {
            (tableView: UITableView, index: Int, item: Any) in
            return TopicItemCellConfigurator(tableView: tableView, item: item)
                .configure(for: IndexPath(row: index, section: 0)) ??
                UITableViewCell()
        }.disposed(by: bag)
    }
    
    
    // MARK: - API Methods
    
    func setItems(_ items: [Any]) {
        items
            .compactMap { TopicItemCellConfigurator.cellClass(for: $0) }
            .forEach { tableView.register($0) }
        itemsSubject.onNext(items)
    }
}
