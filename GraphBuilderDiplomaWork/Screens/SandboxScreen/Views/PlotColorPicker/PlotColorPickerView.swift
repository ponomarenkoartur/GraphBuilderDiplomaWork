//
//  PlotColorPickerView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class PlotColorPickerView: BaseView {
    
    
    // MARK: - Constants
    
    private let cellID = UUID().uuidString
    private static let colors: [UIColor] = [
        #colorLiteral(red: 0.7294117647, green: 0.04705882353, blue: 0.04705882353, alpha: 1), #colorLiteral(red: 0.6352941176, green: 0.7294117647, blue: 0.04705882353, alpha: 1), #colorLiteral(red: 0.7294117647, green: 0.537254902, blue: 0.04705882353, alpha: 1), #colorLiteral(red: 0.04705882353, green: 0.7294117647, blue: 0.6470588235, alpha: 1),
        #colorLiteral(red: 0.04705882353, green: 0.4, blue: 0.7294117647, alpha: 1), #colorLiteral(red: 0.2235294118, green: 0.04705882353, blue: 0.7294117647, alpha: 1), #colorLiteral(red: 0.5529411765, green: 0.04705882353, blue: 0.7294117647, alpha: 1), #colorLiteral(red: 0.9882352941, green: 1, blue: 0.3450980392, alpha: 1),
    ]
    
    
    // MARK: - Properties
    
    // MARK: Callbacks
    
    var didSelectColor: (_ color: UIColor) -> () = { _ in }
    
    // MARK: Views
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.plotColorPallete()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Color"
        label.textColor = Color.defaultText()
        label.font = Font.sfProDisplayRegular(size: 13)
        return label
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = .zero
        return layout
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.register(PlotColorPickerCell.self,
                                forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentOffset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews([
            backgroundImageView,
            titleLabel,
            colorCollectionView
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        snp.makeConstraints {
            $0.width.equalTo(141)
            $0.height.equalTo(88.5)
        }
        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(5)
            $0.top.equalTo(7)
        }
        colorCollectionView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(5)
            $0.width.equalTo(112)
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.bottom.equalToSuperview().offset(-7)
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        Observable.just(Self.colors)
            .bind(to: colorCollectionView.rx.items(
                cellIdentifier: cellID, cellType: PlotColorPickerCell.self)) {
            _, color, cell in cell.color = color
        }
        .disposed(by: bag)
    }
    
    
    // MARK: Static Methods
    
    static func randomColor() -> UIColor {
        colors.randomElement()!
    }
}


// MARK: - UICollectionViewDelegate

extension PlotColorPickerView: UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        if let color = Self.colors[safe: indexPath.row] {
            didSelectColor(color)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(sideLength: 25)
    }
}
