//
//  BaseViewModelViewDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class BaseViewModelViewDataBinder<ViewModel, View>:
    ViewModelViewDataBinderProtocol where ViewModel: ViewModelProtocol {
    
    
    // MARK: - Properties
    
    var viewModel: ViewModel
    var views: [View]
    private(set) var bag = DisposeBag()
    
    
    // MARK: - Initialization
    
    init(viewModel: ViewModel, views: [View]) {
        self.viewModel = viewModel
        self.views = views
    }
    
    
    // MARK: - API Methods
    
    func bind() {
        fatalError("Methods must be overrided")
    }
    
    func unbind() {
        bag = DisposeBag()
    }
}
