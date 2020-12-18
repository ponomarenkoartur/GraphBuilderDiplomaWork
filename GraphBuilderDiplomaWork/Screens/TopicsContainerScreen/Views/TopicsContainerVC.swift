//
//  TopicsContainerVC.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


protocol TopicsContainerVCProtocol: UIViewController {
    var didTapPreviousTopic: () -> () { get set }
    var didTapNextTopic: () -> () { get set }
    var didScrollToPage: (_ index: Int) -> () { get set }
    var didTapProceedToPlotBuildingItem:
        (_ item: TopicProccedToPlotBuildingItem) -> () { get set }
    var topicsList: [Topic] { get set }
    var selectedTopicIndex: Int? { get set }
}

class TopicsContainerVC: BaseVC, TopicsContainerVCProtocol {
    
    
    private enum Constants {
        static let cellID = UUID().uuidString
    }
    
    
    // MARK: - Properties
    
    private var topicsListSubject = BehaviorSubject<[Topic]>(value: [])
    var topicsList: [Topic] {
        get { try! topicsListSubject.value() }
        set { topicsListSubject.onNext(newValue) }
    }
    
    fileprivate var selectedTopicIndexSubject =
        BehaviorSubject<Int?>(value: nil)
    var selectedTopicIndex: Int? {
        get { try! selectedTopicIndexSubject.value() }
        set { selectedTopicIndexSubject.onNext(newValue) }
    }
    
    
    // MARK: Callbacks
    
    var didTapPreviousTopic: () -> () = {}
    var didTapNextTopic: () -> () = {}
    var didScrollToPage: (_ index: Int) -> () = { _ in }
    var didTapProceedToPlotBuildingItem:
        (_ item: TopicProccedToPlotBuildingItem) -> () = { _ in }
    
    
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
                                forCellWithReuseIdentifier: Constants.cellID)
        collectionView.backgroundColor = Color.background()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentOffset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
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
        topicsListSubject
            .bind(to: collectionView.rx.items(cellIdentifier: Constants.cellID)) {
                (index: Int, topic: Topic, cell: UICollectionViewCell) in
                guard let cell = cell as? TopicsContainerCell else { return }
                let serialPosition = SerialPosition
                    .get(forIndex: index, in: self.topicsList)
                
                let vm = TopicVM(topic: topic, position: serialPosition)
                vm.finishCompletion = { reason in
                    if case .didTapBuildPlotInSandbox(let item) = reason {
                        self.didTapProceedToPlotBuildingItem(item)
                    }
                }
                let vc = cell.viewController
                let dataBinder = TopicScreenDataBinder(viewModel: vm,
                                                       views: [vc])
                dataBinder.bind()
                
                vc.didTapPreviousTopic = self.didTapPreviousTopic
                vc.didTapNextTopic = self.didTapNextTopic
            }
            .disposed(by: bag)
        
        selectedTopicIndexSubject
            .subscribe(onNext: { index in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, let index = index else { return }
                    self.collectionView.scroll(to: index,
                                               animated: self.didAppear)
                }
            })
            .disposed(by: bag)
        
        Observable.combineLatest(topicsListSubject, selectedTopicIndexSubject)
            .subscribe(onNext: { topics, selectedTopicIndex in
                if let selectedTopicIndex = selectedTopicIndex {
                    self.title = topics[selectedTopicIndex].title
                } else {
                    self.title = ""
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
