//
//  PlotPresenter.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 29.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import SceneKit


protocol PlotPresenter: GridBoundable {
    var plots: [Plot] { get }
    var nodeScale: SCNVector3 { get }
    /// Adds a plot to the grid.
    /// - Parameter plot: plot to build
    func add(_ plot: Plot)
    /// Replaces the plot at certain index with provided in parameter
    /// - Parameters:
    ///   - plot: new plot
    ///   - index: index of the plot to be replaced
    func rebuild(_ plot: Plot, at index: Int)
    /// Removes the plot at certain index
    /// - Parameter index: index of the plot to be deleted
    func deletePlot(at index: Int)
    func deleteAll()
    /// Changes physical size of the grid and the plot, but the grid scale is still be the same.
    /// - Parameters:
    ///   - x: x-axis scale
    ///   - y: y-axis scale
    ///   - z: z-axis scale
    func scaleNode(x: Float?, y: Float?, z: Float?,
                   animationDuration: TimeInterval)
    /// Changes physical size of the grid and the plot, but the grid scale is still be the same.
    /// - Parameter scale: scale for every axis
    func scaleNode(_ scale: SCNVector3, animationDuration: TimeInterval)
    /// Changes physical size of the grid and the plot, but the grid scale is still be the same.
    /// - Parameter scale: scale for every axis
    func scaleNode(_ scale: Float, animationDuration: TimeInterval)
    /// Reset the scale of the grid to its initial state. Doesn't change physical size of a node.
    func resetGridScale(animationDuration: TimeInterval)
    /// Returns a picture of plots on the grid.
    func screenshot() -> UIImage
}


extension PlotPresenter {
    func scaleNode(_ scale: SCNVector3, animationDuration: TimeInterval = 0) {
        scaleNode(x: scale.x, y: scale.y, z: scale.z,
                  animationDuration: animationDuration)
    }
    
    func scaleNode(_ scale: Float, animationDuration: TimeInterval = 0) {
        scaleNode(x: scale, y: scale, z: scale,
                  animationDuration: animationDuration)
    }
    
    func resetGridScale(animationDuration: TimeInterval) {
        scaleNode(1, animationDuration: animationDuration)
    }
    
    func deleteAll() {
        plots.enumerated().reversed().forEach { index, _ in
            deletePlot(at: index)
        }
    }
    
    func rebuild(_ plot: Plot, at index: Int) {
        deletePlot(at: index)
        add(plot)
    }
}
