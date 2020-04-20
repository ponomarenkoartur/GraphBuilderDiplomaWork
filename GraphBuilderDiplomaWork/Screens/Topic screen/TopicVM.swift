//
//  TopicVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


class TopicVM: BaseVM<TopicVC, NSNull> {
    
    
    // MARK: - Properties
    
    private let topic: Topic
    
    
    // MARK: - Initialization
    
    init(topic: Topic, view: BaseVM<TopicVC, NSNull>.View? = View()) {
        self.topic = topic
        super.init(view: view)
    }
    
}
