//
//  TopicPlotInfoCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import iosMath


class TopicPlotInfoCell: BaseCollectionCell {
    
    
    // MARK: - Properties
    
    private var parametersList: [PlotEquationParameter] = []
    
    // MARK: Callbacks
    
    var didTapPreviousPlotButton: () -> () = {}
    var didTapNextPlotButton: () -> () = {}
    
    // MARK: Views
    
    private lazy var blurView: UIView = {
        let visualEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView.init(effect: visualEffect)
        return view
    }()
    
    private(set) lazy var previousPlotButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.prevPlot())
        button.imageView?.contentMode = .center
        button.snp.makeConstraints {
            $0.width.equalTo(42)
            $0.height.equalTo(65)
        }
        button.rx.tap
            .subscribe(onNext: { _ in self.didTapPreviousPlotButton() })
            .disposed(by: bag)
        return button
    }()
    
    private(set) lazy var nextPlotButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.nextPlot())
        button.imageView?.contentMode = .center
        button.snp.makeConstraints {
            $0.width.equalTo(42)
            $0.height.equalTo(65)
        }
        button.rx.tap
            .subscribe(onNext: { _ in self.didTapNextPlotButton() })
            .disposed(by: bag)
        return button
    }()
    
    private lazy var equationLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.textColor = Color.defaultText()!
        return label
    }()
    
    private lazy var parametersTableView: UITableView = {
        let tableView = UITableView()

        tableView.dataSource = self
        tableView.register(TopicPlotParameterCell.self)
        tableView.register(ProceedToSandboxCell.self)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
                
        tableView.tableHeaderView = TopicPlotParameterHeaderView(
            frame: CGRect(height: 30))
        tableView.tableFooterView = UIView(frame: CGRect(height: 100))
        
        return tableView
    }()
    
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.round([.topLeft, .topRight], radius: 5)
    }
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubviews([
            blurView, previousPlotButton, equationLabel, nextPlotButton,
            parametersTableView
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        previousPlotButton.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        nextPlotButton.snp.makeConstraints { $0.top.right.equalToSuperview() }
        equationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(previousPlotButton.snp.centerY)
        }
        parametersTableView.snp.makeConstraints {
            $0.top.equalTo(previousPlotButton.snp.bottom)
                .offset(WindowSafeArea.insets.bottom + 5)
            $0.bottom.equalToSuperview()
            $0.width.centerX.equalToSuperview()
        }
    }
    
    
    // MARK: - API Methods
    
    func setEquationText(_ equation: String?) {
        equationLabel.latex = equation
    }
    
    func setParametersList(_ list: [PlotEquationParameter]) {
        parametersList = list
        parametersTableView.reloadData()
    }
}


// MARK: - UITableViewDataSource

extension TopicPlotInfoCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // The last cell is 'To Sandbox' cell
        parametersList.count + 1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isParameterCell = indexPath.row < parametersList.count
        guard isParameterCell else {
            let cell = tableView
                .dequeue(ProceedToSandboxCell.self, for: indexPath) ??
                         ProceedToSandboxCell()
            return cell
        }
        let cell = tableView
            .dequeue(TopicPlotParameterCell.self, for: indexPath) ??
            TopicPlotParameterCell()
        let parameter = parametersList[indexPath.row]
        TopicPlotParameterCellConfigurator(cell: cell)
            .configure(with: parameter)
        return cell
    }
}
