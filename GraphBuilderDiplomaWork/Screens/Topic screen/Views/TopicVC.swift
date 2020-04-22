//
//  TopicVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources


class TopicVC: BaseVC {
    
    
    // MARK: - Properties
    
    
    
    private var topicSubscription: Disposable?
    private var topicItemsTableSubscription: Disposable?
    var topic: Observable<Topic>? {
        didSet {
            topicSubscription?.dispose()
            topicItemsTableSubscription?.dispose()
            setupTopicBinding()
            setupTableViewDataBinding()
        }
    }
    var topicItems: Observable<[TopicContentItem]>? {
        topic?.map { $0.content }
    }
    
    
    private var serialPositionSubscription: Disposable?
    var serialPosition: Observable<SerialPosition?>? {
        didSet {
            serialPositionSubscription?.dispose()
            setupSerialPositionBinding()
        }
    }
    
    var didTapProceedToPlotBuildingItem:
        (_ item: TopicProccedToPlotBuildingItem) -> () = { _ in }
    var didTapPreviousTopic: () -> () = {}
    var didTapNextTopic: () -> () = {}
    
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TopicCell.self)
        tableView.allowsSelection = false
        tableView.tableFooterView = tableViewFooter
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private lazy var tableViewFooter: TopicFooterView = {
        let view = TopicFooterView()
        view.didTapPreviousTopic = { self.didTapPreviousTopic() }
        view.didTapNextTopic = { self.didTapNextTopic() }
        return view
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
        setupTopicBinding()
        setupSerialPositionBinding()
        setupTableViewDataBinding()
    }
    
    private func setupTopicBinding() {
        topicSubscription = topic?
            .subscribe(onNext: { topic in
                self.title = topic.title
                topic.content
                    .compactMap { TopicItemCellConfigurator.cellClass(for: $0) }
                    .forEach { self.tableView.register($0) }
                
            })
        topicSubscription?.disposed(by: bag)
    }
    
    private func setupSerialPositionBinding() {
        serialPositionSubscription = serialPosition?
            .subscribe(onNext: {
                self.tableViewFooter.buttons = self.getFooterButtons(for: $0)
            })
        serialPositionSubscription?.disposed(by: bag)
    }
    
    private func setupTableViewDataBinding() {
        topicItemsTableSubscription = topicItems?
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, item: TopicContentItem) in
                
                // Configuring appearance
                let cell =
                    TopicItemCellConfigurator(tableView: tableView, item: item)
                        .configure(for: IndexPath(row: index)) ??
                        UITableViewCell()
                
                // Settings callbacks
                if let cell = cell as? TopicProccedToPlotBuildingCell,
                    let item = item as? TopicProccedToPlotBuildingItem {
                    cell.didTap = { self.didTapProceedToPlotBuildingItem(item) }
                }
                
                return cell
        }
            
        topicItemsTableSubscription?.disposed(by: bag)
    }
    
    
    // MARK: - Private Methods
    
    private func getFooterButtons(for serialPosistion: SerialPosition?)
        -> Set<TopicFooterView.Button> {
            switch serialPosistion {
            case .first:
                return [.next]
            case .middle:
                return [.previous, .next]
            case .last:
                return [.previous]
            case .none:
                return []
            }
    }
    
    
    private func disposeAllSubscriptions() {
        topicSubscription?.dispose()
        topicItemsTableSubscription?.dispose()
        serialPositionSubscription?.dispose()
    }
}
