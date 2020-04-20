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
    
    private let itemsSubject = BehaviorSubject<[CellPresentable]>(value: [])
    var items: Observable<[CellPresentable]>? { itemsSubject.asObservable() }
    
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TopicCell.self)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    

    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        title = "Topics"
    }
    
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
            (tableView: UITableView, index: Int, item: CellPresentable) in
            return TopicItemCellConfigurator(tableView: tableView, item: item)
                .configure(for: IndexPath(row: index, section: 0)) ??
                UITableViewCell()
        }.disposed(by: bag)
    }
    
    
    // MARK: - API Methods
    
    func setItems(_ items: [CellPresentable]) {
        items.forEach { tableView.register($0.cellPresentation) }
        itemsSubject.onNext(items)
    }
}
