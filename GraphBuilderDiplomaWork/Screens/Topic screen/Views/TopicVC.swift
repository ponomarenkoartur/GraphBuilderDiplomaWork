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
    
    var topic: Observable<Topic>?
    var topicItems: Observable<[TopicContentItem]>? {
        topic?.map { $0.content }
    }
    var didTapProceedToPlotBuildingItem:
        (_ item: TopicProccedToPlotBuildingItem) -> () = { _ in }
    
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
        topic?
            .subscribe(onNext: { self.title = $0.title })
            .disposed(by: bag)
        topicItems?
            .subscribe(onNext: { items in
                items
                    .compactMap { TopicItemCellConfigurator.cellClass(for: $0) }
                    .forEach { self.tableView.register($0) }
            })
            .disposed(by: bag)
        topicItems?
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, item: TopicContentItem) in
                
                // Configuring appearance
                let cell =
                    TopicItemCellConfigurator(tableView: tableView, item: item)
                        .configure(for: IndexPath(row: index, section: 0)) ??
                    UITableViewCell()
                
                // Settings callbacks
                if let cell = cell as? TopicProccedToPlotBuildingCell,
                    let item = item as? TopicProccedToPlotBuildingItem {
                    cell.didTap = {
                        self.didTapProceedToPlotBuildingItem(item)
                    }
                }
                
                return cell
            }
            .disposed(by: bag)
    }
}
