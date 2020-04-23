//
//  ViewModelViewDataBinderProtocol.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


protocol ViewModelViewDataBinderProtocol: class {
    associatedtype ViewModel where ViewModel: ViewModelProtocol
    associatedtype View
    
    var viewModel: ViewModel { get }
    var views: [View] { get }
    
    func bind()
}
