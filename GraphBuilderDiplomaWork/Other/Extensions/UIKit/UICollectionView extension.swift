//
//  UICollectionView extension.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeue<T: UICollectionViewCell>(
        _ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(
            withReuseIdentifier: String(describing: cellClass),
            for: indexPath) as? T
    }
    
    func scroll(to page: Int, section: Int = 0,
                at position: ScrollPosition = .left, animated: Bool = true) {
        scrollToItem(at: IndexPath(row: page, section: section), at: position,
                     animated: animated)
    }
}
