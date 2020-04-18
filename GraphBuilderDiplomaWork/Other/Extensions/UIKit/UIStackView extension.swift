//
//  UIStackView extension.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit


// MARK: - Subviews

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
    
    func highlight(color: UIColor = .red, semitransparent: Bool = true) {
        let view = UIView()
        view.backgroundColor =
            semitransparent ? color.withAlphaComponent(0.2) : color
        addSubview(view)
        view.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
