//
//  TopicsListVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class TopicsListVM: BaseVM<TopicsListVC, TopicsListVM.FinishCompletionReason> {
    
    
    // MARK: - Enums
    
    enum FinishCompletionReason {
        case didSelectTopic(topic: Topic, serialPosition: SerialPosition?)
    }
    
    
    // MARK: - Properties
    
    private let topicsListSubject = BehaviorSubject<[Topic]>(value:
        [
            Topic(title: "Hello",
                  shortDescription: "This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. "),
            Topic(title: "World",
                  shortDescription: "This is short description of \"World\" topic",
                  content: [
                    TopicSubheader(text: "Subheader"),
                    TopicParagraph(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                    TopicIllustration(image: Image.topicPlaceholder()!, height: 100),
                    TopicProccedToPlotBuildingItem(graph: "y+2"),
                ]
            ),
            Topic(title: "!",
            shortDescription: "This is short description of \"!\" topic."),
        ]
    )
    
    private var topicsList: Observable<[Topic]> {
        topicsListSubject.asObservable()
    }
    
    private var topicsListValue: [Topic] {
        (try? topicsListSubject.value()) ?? []
    }
    
    
    // MARK: - Initialization
    
    init() {
        super.init(view:
            TopicsListVC(topicsList: topicsListSubject.asObservable()))
        setupCallbacks()
    }
    
    
    private func setupCallbacks() {
        viewController?.didSelectTopic = { index in
            
            if let topic = self.topicsListValue[safe: index] {
                let position = SerialPosition.get(forIndex: index,
                                                  in: self.topicsListValue)
                self.finishCompletion(.didSelectTopic(topic: topic,
                                                      serialPosition: position))
            }
        }
    }
    
    
}
