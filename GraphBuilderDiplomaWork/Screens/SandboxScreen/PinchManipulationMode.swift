//
//  ManipulationMode.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 14.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation

// MARK: - Enums

enum PlotManipulationMode {
    /// Mode when physical size or position is being chaged
    case world
    /// Mode when max and min values of every axis is being changed
    case local
}
