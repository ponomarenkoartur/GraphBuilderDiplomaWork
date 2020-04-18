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
        imageView.snp.makeConstraints { $0.height.equalTo(111) }
        imageView.contentMode = .scaleAspectFit
        imageView.image = Image.arGraphLogo()
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WelcomeScreenMenuCell.self)
        tableView.rowHeight = 60
        tableView.delegate = self
        return tableView
    }()
    
    
    // MARK: - Setup Methods
    
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(174)
            $0.width.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(imageView.snp.bottom).offset(-10)
            $0.height.equalTo(122)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-92)
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
