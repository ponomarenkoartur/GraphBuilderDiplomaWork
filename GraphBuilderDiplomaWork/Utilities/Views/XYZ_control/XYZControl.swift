//
//  XYZControl.swift
//  XYZ_control
//
//  Created by Artur on 09.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift


protocol XYZControlDelegate: class {
    func xyzControl(_ control: XYZControl, didSelectAxis: Axis,
                    isSelected: Bool)
}

class XYZControl: BaseView {
    
    // MARK: - Completions
    
    var didSelectAxis: (_ axis: Axis, _ isSelected: Bool) -> () = { _, _ in }
    
    
    // MARK: - Properties
    
    private var xSubject = BehaviorSubject(value: false)
    private var ySubject = BehaviorSubject(value: false)
    private var zSubject = BehaviorSubject(value: false)
    
    var xObservable: Observable<Bool> { xSubject.asObservable() }
    var yObservable: Observable<Bool> { ySubject.asObservable() }
    var zObservable: Observable<Bool> { zSubject.asObservable() }
    
    var x: Bool {
        get { (try? xSubject.value()) ?? false }
        set { xSubject.onNext(newValue) }
    }
    var y: Bool {
        get { (try? ySubject.value()) ?? false }
        set { ySubject.onNext(newValue) }
    }
    var z: Bool {
        get { (try? zSubject.value()) ?? false }
        set { zSubject.onNext(newValue) }
    }
    var axisesSelection: (x: Bool, y: Bool, z: Bool) {
        get { (x, y, z) }
        set {
            assignIfNotEqual(&x, newValue.x)
            assignIfNotEqual(&y, newValue.y)
            assignIfNotEqual(&z, newValue.z)
        }
    }
    
    
    weak var delegate: XYZControlDelegate?
    
    
    // MARK: Views
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        setupGestures()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(imageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func setupBinding() {
        super.setupBinding()
        xSubject
            .subscribe(onNext: {
                self.didSelectAxis(.x, $0)
                self.delegate?.xyzControl(self, didSelectAxis: .x,
                                          isSelected: $0)
            })
            .disposed(by: bag)
        ySubject
            .subscribe(onNext: {
                self.didSelectAxis(.y, $0)
                self.delegate?.xyzControl(self, didSelectAxis: .y,
                                          isSelected: $0)
            })
            .disposed(by: bag)
        zSubject
            .subscribe(onNext: {
                self.didSelectAxis(.z, $0)
                self.delegate?.xyzControl(self, didSelectAxis: .z,
                                          isSelected: $0)
            })
            .disposed(by: bag)
        Observable.combineLatest(xSubject, ySubject, zSubject)
            .subscribe(onNext: { x, y, z in
                self.imageView.image = self.imageForValues(x: x, y: y, z: z)
            })
            .disposed(by: bag)
    }
    
    private func setupGestures() {
        let tapGR = UITapGestureRecognizer(
            target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGR)
    }
    
    @objc
    private func handleTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedPoint = tapGestureRecognizer.location(in: self)
        let axis = self.axis(for: tappedPoint)
        switch axis {
        case .x:
            xSubject.onNext(!x)
        case .y:
            ySubject.onNext(!y)
        case .z:
            zSubject.onNext(!z)
        default:
            break
        }
    }
    
    // MARK: - API Methods
    
    /// Function transform point to other coordinates
    /// Original coorindate has origin in the top left corner of view, x is directed to right, y is directed to bottom.
    /// Transformed coorindate has origin in center of view, x is also directed to right, but y is directed to top.
    func transformCoordinateToCenterOrigin(_ originalCoordinate: CGPoint) -> CGPoint {
        //                  y1
        //                   ˄
        //  A0(0, 0).________|______________>x0
        //          |        |        |
        //          |        |        |
        //          |        |        |
        //          |        |        |
        //       ------------‧------------->x1
        //          |        |A1(0, 0)|
        //          |        |        |
        //          |        |        |
        //          |________|________|
        //          |        |
        //          |        |
        //          |        |
        //          V        |
        //          y0
        //
        //
        //  A0 – original coordinate
        //  A1 – transformed coordinate
        //
        
        CGPoint(x: originalCoordinate.x - (frame.height / 2),
                y: -originalCoordinate.y + (frame.width / 2))
    }
    
    /// Returns tapped axis for tapped point.
    func axis(for coordinate: CGPoint) -> Axis? {
        let originalCoordinate = coordinate
        let transformedCoordinate = transformCoordinateToCenterOrigin(originalCoordinate)
        
        //
        //          ___________________
        //         |                   |
        //         |_                 _|
        //         | \_             _/ |
        //         |   \_    X    _/   |
        //         |     \_     _/     |
        //         |       \_ _/       |
        //         |    Z    |    Y    |
        //         |         |         |
        //         |_________|_________|
        //
        //
        let tan30 = sqrt(3) / 3
        let x = Double(transformedCoordinate.x)
        let y = Double(transformedCoordinate.y)
        switch (x, y) {
        case let (x, y) where y > abs(x * tan30):
            return .y
        case let (x, y) where (y < x * tan30) && x > 0:
            return .x
        case let (x, y) where (y < -x * tan30) && x < 0:
            return .z
        default:
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    private func imageForValues(x: Bool, y: Bool, z: Bool) -> UIImage? {
        let xName = x ? "x" : "_"
        let yName = y ? "y" : "_"
        let zName = z ? "z" : "_"
        let imageName = xName + yName + zName
        return UIImage(named: imageName)
    }
}
