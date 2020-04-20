//
//  WelcomeVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import AttributedString
import RxSwift


class WelcomeVC: BaseVC {
    
    
    // MARK: - Properties
    
    var didSelectRow: (_ index: Int) -> () = { _ in }
    var menuItems: [String]? {
        didSet {
            Observable.of(menuItems ?? []).bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: String) in
                let cell =
                    tableView.dequeue(WelcomeScreenMenuCell.self, for: index) ??
                    WelcomeScreenMenuCell()
                cell.labelText = element
                cell.labelTextColor = index.isMultiple(of: 2) ?
                    Color.defaultText() : Color.turquoise()
                return cell
            }.disposed(by: bag)
        }
    }
    
    
    // MARK: Views
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Image.arGraphLogo()
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WelcomeScreenMenuCell.self)
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    
    // MARK: - Setup Methods
    
    
    override func setupUI() {
        super.setupUI()
        shouldPresentNavigationBar = false
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews([
            imageView,
            tableView
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        imageView.snp.makeConstraints {
            $0.height.equalTo(140)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(174)
                .priority(997)
            $0.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.top)
                .offset(50)
                .priority(998)
            $0.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.top)
                .offset(10)
            $0.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.top)
                .offset(10)
            $0.width.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualTo(tableView.snp.top).offset(-20)
        }
        tableView.snp.makeConstraints {
            $0.height.equalTo(122)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-92)
                .priority(998)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom)
                .offset(-5)
                .priority(999)
            $0.width.centerX.equalToSuperview()
        }
    }
}


// MARK: - UITableViewDelegate

extension WelcomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectRow(indexPath.row)
    }
}
