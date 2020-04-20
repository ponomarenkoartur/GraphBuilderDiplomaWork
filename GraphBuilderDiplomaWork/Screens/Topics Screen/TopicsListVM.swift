//
//  TopicsListVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class TopicsListVM: BaseVM<TopicsListVC, NSNull> {
    
    
    // MARK: - Properties
    
    private let topicsList: Observable<[Topic]> = Observable.just([
        Topic(title: "Hello",
              shortDescription: "This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. ",
              imagePreview: nil),
        Topic(title: "World",
              shortDescription: "This is short description of \"World\" topic",
              imagePreview: nil),
    ])
    
    
    // MARK: - Initialization
    
    init() {
        super.init(view: TopicsListVC(topicsList: topicsList))
    }
    
}
