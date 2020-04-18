//
//  BaseVCWithVMProtocol.swift
//  p138
//
//  Created by artur_ios on 15.01.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit

protocol BaseVCWithVMProtocol where Self: BaseVC {
    associatedtype VMType: ViewModelProtocol
    var viewModel: VMType? { get }
}
