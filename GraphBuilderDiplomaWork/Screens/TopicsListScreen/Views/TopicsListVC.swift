//
//  TopicsListVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


protocol TopicsListVCProtocol: UIViewController {
    var didSelectTopic: (_ index: Int) -> () { get set }
    var topics: [Topic] { get set }
}

class TopicsListVC: BaseVC, TopicsListVCProtocol {
    
    
    // MARK: - Properties
    
    private var topicsSubject = BehaviorSubject<[Topic]>(value: [])
    var topics: [Topic] {
        get { try! topicsSubject.value() }
        set { topicsSubject.onNext(newValue) }
    }
    
    
    
    // MARK: Callbacks
    
    var didSelectTopic: (_ index: Int) -> () = { _ in }
    
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TopicCell.self)
        tableView.delegate = self
        topicsSubject.bind(to: tableView.rx.items) {
            (tableView: UITableView, index: Int, topic: Topic) in
            let cell =
                tableView.dequeue(TopicCell.self, for: index) ?? TopicCell()
            TopicCellConfigurator(cell: cell).configure(with: topic)
            return cell
        }.disposed(by: bag)
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
        view.layoutIfNeeded()
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
