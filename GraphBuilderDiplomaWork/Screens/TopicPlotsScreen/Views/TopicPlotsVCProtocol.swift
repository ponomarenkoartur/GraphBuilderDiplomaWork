//
//  TopicPlotsVCProtocol.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit

protocol TopicPlotsVCProtocol: UIViewController {
    var didChangeSelectedPlotIndex: (_ index: Int) -> () { get set }
    func setPlotList(_ list: [String])
    func setSelectedPlotIndex(_ index: Int)
}
