//
//  RecognitionContentView.swift
//  EquationRecognition
//
//  Created by artur_ios on 19.11.2019.
//  Copyright © 2019 Artur. All rights reserved.
//

import UIKit
import SnapKit
import iosMath
import ARKit
import RxCocoa
import RxSwift


protocol RecognitionContentViewDataSource: class {
    func recognizedEquationsCount(for view: RecognitionContentView) -> Int
    func recognizedEquation(for view: RecognitionContentView, at index: Int) -> String
}

protocol RecognitionContentViewDelegate: class {
    func recognizedEquationContentView(_ view: RecognitionContentView,
                                       didSelectEquationAt index: Int)
    func recognizedEquationContentView(_ view: RecognitionContentView,
                                       sliderValueChanges value: Float)
}


class RecognitionContentView: UIView {
    
    
    // MARK: - Constants
    
    private let resultViewFullHeight: CGFloat = 300
    private let resultViewHiddenHeight: CGFloat = 40
    
    
    // MARK: - Outlets
    
    private(set) var arView: GraphARSCNView!
    private var tableView: UITableView!
    private var errorLabel: UILabel!
    private var resultView: UIView!
    
    private var slider = UISlider()
    
    
    
    // MARK: - Properties
    
    private var activityIndicator: UIActivityIndicatorView!
    
    weak var dataSource: RecognitionContentViewDataSource!
    weak var delegate: RecognitionContentViewDelegate!
    
    private var resultViewIsHidden = false
    
    private var bag = DisposeBag()
    
    
    // MARK: - Callbacks
    
    var tappedCallback: (() -> Void)?
    var buildButtonTappedCallback: (() -> Void)?
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        markup()
        setupActivityIndicator()
        setupTableView()
        setupARView()
        registerGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Markup
    
    private func markup() {
        markupTableView()
        markupARView()
        markupSlider()
    }
    
    private func markupARView() {
        arView = GraphARSCNView()
        addSubview(arView)
        arView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(tableView.snp.top)
        }
    }
    
    private func markupTableView() {
        tableView = UITableView()
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(150)
        }
    }
    
    private func markupSlider() {
        addSubview(slider)
        slider.minimumValue = -10
        slider.maximumValue = 10
        addSubview(slider)
        slider.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().offset(10)
        }
        
        slider.rx.value
            .throttle(DispatchTimeInterval.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                self.delegate?.recognizedEquationContentView(self, sliderValueChanges: $0)
            })
            .disposed(by: bag)
    }
    
    
    // MARK: - Setup Methods
    
    private func setupTableView() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "EquationCell", bundle: nil), 
                           forCellReuseIdentifier: "EquationCell")
    }
    
    private func setupActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        }
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top)
            maker.left.equalTo(self.snp.left)
            maker.right.equalTo(self.snp.right)
            maker.bottom.equalTo(self.snp.bottom)
        }
    }
    
    private func setupARView() {
        arView.autoenablesDefaultLighting = true
    }
    
    
    // MARK: - Gestures
    
    private func registerGestureRecognizers() {
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(handleTap))
        arView.addGestureRecognizer(tapGR)
    }
    
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        tappedCallback?()
    }
    
    
    // MARK: - Actions
    
    @IBAction private func showHideButtonTapped(_ sender: UIButton) {
        setResultsViewHidden(!resultViewIsHidden)
    }
    
    @IBAction private func buildButtonTapped(_ sender: UIButton) {
        buildButtonTappedCallback?()
    }
    
    
    // MARK: - API Methods
    
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func setErrorText(_ text: String?) {
        errorLabel.text = text
    }
    
    func setResultsViewHidden(_ isHidden: Bool, animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
//            self.tableViewHeightConstraint.constant = isHidden ?
//                self.resultViewHiddenHeight : self.resultViewFullHeight
            self.resultViewIsHidden = isHidden
            self.layoutIfNeeded()
        }
    }
}


// MARK: - UITableViewDataSource

extension RecognitionContentView: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.recognizedEquationsCount(for: self)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: "EquationCell",
                                 for: indexPath) as? EquationCell else {
            return UITableViewCell()
        }
        
        let equation = dataSource.recognizedEquation(for: self, at: indexPath.row)
        cell.setLatex(equation)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension RecognitionContentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.recognizedEquationContentView(
            self, didSelectEquationAt: indexPath.row)
    }
}
