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


protocol TopicVCProtocol: UIViewController {
    var didTapProceedToPlotBuildingItem:
        (_ item: TopicProccedToPlotBuildingItem) -> () { get set }
    var topic: Topic? { get set }
    func setSerialPosition(_ serialPosition: SerialPosition?)
}


class TopicVC: BaseVC, TopicVCProtocol {
    
    
    // MARK: - Properties
    
    
    
    fileprivate let topicSubject = BehaviorSubject<Topic?>(value: nil)
    var topic: Topic? {
        get { try! topicSubject.value() }
        set { topicSubject.onNext(newValue) }
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
        setupTableViewDataBinding()
    }
    
    private func setupTopicBinding() {
        topicSubject
            .subscribe(onNext: { topic in
                guard let topic = topic else { return }
                self.title = topic.title
                topic.content
                    .compactMap { TopicItemCellConfigurator.cellClass(for: $0) }
                    .forEach { self.tableView.register($0) }
            })
            .disposed(by: bag)
    }
    
    private func setupTableViewDataBinding() {
        topicSubject.compactMap { $0?.content }
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
        }.disposed(by: bag)
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
            case .none, .alone:
                return []
            }
    }
    
    
    // MARK: - API Methods
    
    func setSerialPosition(_ serialPosition: SerialPosition?) {
        tableViewFooter.buttons = getFooterButtons(for: serialPosition)
    }
}


// MARK: - Rx

extension Reactive where Base == TopicVC {
    var topic: Observable<Topic?> {
        base.topicSubject.asObservable()
    }
}
