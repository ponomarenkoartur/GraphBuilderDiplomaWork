//
//  BaseVMWithVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class BaseVMWithVC<VC, FinishCompletionReason>:
    BaseVM<FinishCompletionReason> where VC: UIViewController {
        
    // MARK: - Properties
    
    var viewController: VC?
    
    
    // MARK: - Initialization
    
    init(viewController: VC? = VC()) {
        self.viewController = viewController
        super.init()
    }
}
