//
//  GridBoundable.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 14.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


protocol GridBoundable {
    /// Changes the bounds of the grid. The grid is still having the same physical size, but changes its scale
    /// - Parameters:
    ///   - x: x-axis bounds
    ///   - y: y-axis bounds
    ///   - z: z-axis bounds
    func setBounds(x: ValuesBounds?, y: ValuesBounds?, z: ValuesBounds?)
    /// Changes the bounds of the grid. The grid is still having the same physical size, but changes its scale
    func setBounds(_ gridBounds: GridBounds)
}

extension GridBoundable {
    func setBounds(_ gridBounds: GridBounds) {
        setBounds(x: gridBounds.x, y: gridBounds.y, z: gridBounds.z)
    }
}
