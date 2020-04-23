//
//  TopicsContainerVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class TopicsContainerVC: BaseVC {
    
    
    // MARK: - Constants
    
    private let cellID = UUID().uuidString
    
    
    // MARK: - Properties
    
    var topicsList: Observable<[Topic]>
    var selectedTopicIndex: Observable<Int>?
    private var lastTopicsListValue: [Topic] = []
    
    
    // MARK: Callbacks
    
    var didTapPreviousTopic: () -> () = {}
    var didTapNextTopic: () -> () = {}
    var didScrollToPage: (_ index: Int) -> () = { _ in }
    
    
    // MARK: Views
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.register(TopicsContainerCell.self,
                                forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = Color.background()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentOffset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    
    // MARK: - Initialization
    
    init(topicsList: Observable<[Topic]>,
         selectedTopicIndex: Observable<Int>? = nil) {
        self.selectedTopicIndex = selectedTopicIndex
        self.topicsList = topicsList
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(topicsList:) must be used")
    }
    
    required init() {
        fatalError("init(topicsList:) must be used")
    }
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        title = "Hello"
        shouldPreferLargeTitle = false
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        collectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        topicsList
            .subscribe(onNext: { self.lastTopicsListValue = $0 })
            .disposed(by: bag)
        topicsList
            .bind(to: collectionView.rx.items(cellIdentifier: cellID)) {
                (index: Int, topic: Topic, cell: UICollectionViewCell) in
                guard let cell = cell as? TopicsContainerCell else { return }
                cell.viewController.topic = Observable<Topic>.just(topic)
                let serialPosition = SerialPosition
                    .get(forIndex: index, in: self.lastTopicsListValue)
                cell.viewController.serialPosition =
                    Observable.just(serialPosition)
                cell.viewController.didTapPreviousTopic = {
                    self.didTapPreviousTopic()
                }
                cell.viewController.didTapNextTopic = {
                    self.didTapNextTopic()
                }
            }
            .disposed(by: bag)
        
        selectedTopicIndex?
        .subscribe(onNext: { index in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.scroll(to: index, animated: self.didAppear)
                
            }
            
        })
        .disposed(by: bag)
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension TopicsContainerVC: UICollectionViewDelegate,
                             UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TopicsContainerCell else { return }
        cell.viewController.didMove(toParent: self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let page = collectionView.pageIndex {
            didScrollToPage(page)
        }
    }
}
