//
//  PlotViewProtocol.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 29.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import SceneKit


protocol PlotViewProtocol: UIView {
    var plots: [Plot] { get }
    /// Adds a plot to the grid.
    /// - Parameter plot: plot to build
    func build(_ plot: Plot)
    /// Replaces the plot at certain index with provided in parameter
    /// - Parameters:
    ///   - plot: new plot
    ///   - index: index of the plot to be replaced
    func rebuild(_ plot: Plot, at index: Int)
    /// Removes the plot at certain index
    /// - Parameter index: index of the plot to be deleted
    func deletePlot(at index: Int)
    /// Changes the scale of the grid. The grid is still having the same physical size, but changes its scale
    /// - Parameters:
    ///   - x: x-axis scale
    ///   - y: y-axis scale
    ///   - z: z-axis scale
    func scaleGrid(x: Float?, y: Float?, z: Float?)
    /// Changes the scale of the grid. The grid is still having the same physical size, but changes its scale
    /// - Parameter scale: scale for every axis
    func scaleGrid(_ scale: SCNVector3)
    /// Changes physical size of the grid and the plot, but the grid scale is still be the same.
    /// - Parameters:
    ///   - x: x-axis scale
    ///   - y: y-axis scale
    ///   - z: z-axis scale
    func scaleNode(x: Float?, y: Float?, z: Float?)
    /// Changes physical size of the grid and the plot, but the grid scale is still be the same.
    /// - Parameter scale: scale for every axis
    func scaleNode(_ scale: SCNVector3)
    /// Reset the scale of the grid to its initial state. Doesn't change physical size of a node.
    func resetGridScale()
    /// Returns a picture of plots on the grid.
    func screenshot() -> UIImage
}
