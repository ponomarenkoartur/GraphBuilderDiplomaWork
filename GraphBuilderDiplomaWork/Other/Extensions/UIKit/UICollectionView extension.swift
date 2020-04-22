//
//  UICollectionView extension.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    enum PageScrollError: Error {
        case noPrevPage, noNextPage, cantDetermineCurrentPage
    }
    
    var pageIndex: Int? {
        guard frame.size.width != 0 else { return nil }
        return Int(contentOffset.x / frame.size.width)
    }
    
    var lastPage: Int? {
        guard frame.size.width != 0 else { return nil }
        return Int(contentSize.width / frame.size.width) - 1
    }
    
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
    
    func scrollIfNeeded(
        to page: Int, section: Int = 0, at position: ScrollPosition = .left,
        animated: Bool = true) {
        if pageIndex != page {
            scroll(to: page, section: section, at: position, animated: animated)
        }
    }
    
    func scrollToPreviousPage() throws {
        guard let pageIndex = pageIndex else {
            throw PageScrollError.cantDetermineCurrentPage
        }
        guard pageIndex != 0 else {
            throw PageScrollError.noPrevPage
        }
        scroll(to: pageIndex - 1)
    }
    
    func scrollToNextPage() throws {
        guard let pageIndex = pageIndex else {
            throw PageScrollError.cantDetermineCurrentPage
        }
        guard pageIndex != lastPage else {
            throw PageScrollError.noNextPage
        }
        scroll(to: pageIndex + 1)
    }
}
