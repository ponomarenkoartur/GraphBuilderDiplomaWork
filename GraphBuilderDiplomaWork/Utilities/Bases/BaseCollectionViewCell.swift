//
//  BaseCollectionViewCell.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit
import RxSwift


class BaseCollectionCell: UICollectionViewCell {
    
    
    // MARK: - Properties
    
    let bag = DisposeBag()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIAfterLayoutSubviews()
    }
    
    
    /// Call 'addSubview' methods before caliing super.setupUI()
    /// in overrided methods
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func setupUIAfterLayoutSubviews() {}
    
    func addSubviews() {}
    
    func setupConstraints() {}
}
