//
//  UITableView extension.swift
//  LimoDad
//
//  Created by artur_ios on 11.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//


import UIKit

extension UITableView {
    func register(_ cellClass: AnyClass) {
        register(cellClass,
                 forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeue<T: UITableViewCell>(
        _ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: String(describing: cellClass),
                            for: indexPath) as? T
    }
    
    func dequeue<T: UITableViewCell>(
        _ cellClass: T.Type, for row: Int) -> T? {
        dequeue(cellClass, for: IndexPath(row: row, section: 0))
    }
    
    func scroll(to item: Int, section: Int = 0,
                at position: ScrollPosition = .top, animated: Bool = true) {
        scrollToRow(at: IndexPath(row: item, section: section), at: position,
                     animated: animated)
    }
    
    func deleteRows(at indexPath: IndexPath,
                    with animation: RowAnimation = .automatic) {
        deleteRows(at: [indexPath], with: animation)
    }
}
