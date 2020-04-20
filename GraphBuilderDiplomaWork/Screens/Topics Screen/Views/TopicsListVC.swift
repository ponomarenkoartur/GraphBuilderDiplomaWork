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
    
    var topicsList: Observable<[Topic]>
    
    
    // MARK: Callbacks
    
    var didSelectTopic: (_ index: Int) -> () = { _ in }
    
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TopicCell.self)
        tableView.delegate = self
        return tableView
    }()
    
    
    // MARK: - Initialization
    
    
    init(topicsList: Observable<[Topic]>) {
        self.topicsList = topicsList
        super.init()
    }
    
    required init() {
        fatalError("Use init(topicsList:) instead")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(topicsList:) instead")
    }
    

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
        topicsList.bind(to: tableView.rx.items) {
            (tableView: UITableView, index: Int, topic: Topic) in
            let cell =
                tableView.dequeue(TopicCell.self, for: index) ?? TopicCell()
            TopicCellConfigurator(cell: cell).configure(with: topic)
            return cell
        }.disposed(by: bag)
    }
}


// MARK: UITableViewDelegate

extension TopicsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectTopic(indexPath.row)
    }
}
