//
//  EquationCell.swift
//  EquationRecognition
//
//  Created by artur_ios on 20.11.2019.
//  Copyright © 2019 Artur. All rights reserved.
//

import UIKit
import iosMath

class EquationCell: UITableViewCell {

    
    // MARK: - Outlets
    
    @IBOutlet weak var latexLabel: MTMathUILabel!
    
    
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabelUI()
    }
    
    
    // MARK: - Setup Methods
    
    private func setupLabelUI() {
        latexLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
    
    
    // MARK: - API Methods
    
    func setLatex(_ string: String?) {
        latexLabel.latex = string
    }

}
