//
//  BaseTableViewCell.swift
//  LimoDad
//
//  Created by artur_ios on 11.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit
import RxSwift


class BaseTableViewCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    let bag = DisposeBag()
    private(set) var externalBindingBag = DisposeBag()
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupBinding()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupBinding()
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
    
    func setupBinding() {}
    
    func resetExternalBinding() {
        externalBindingBag = DisposeBag()
    }
}
