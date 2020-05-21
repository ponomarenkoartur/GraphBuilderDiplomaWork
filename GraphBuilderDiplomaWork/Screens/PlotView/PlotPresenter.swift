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
    var gridBounds: GridBounds { get }
    var plotsAndGridWrapperPosition: SCNVector3 { get }
    var axisesRotationAngles: SCNVector3 { get }
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
    /// Changes grid bounds
    func setBounds(x: ValuesBounds?, y: ValuesBounds?, z: ValuesBounds?)
    /// Changes grid bounds
    func setBounds(_ bounds: ValuesBounds)
    /// Moves in physycal world the whole root node
    func setRootPosition(x: Float?, y: Float?, z: Float?)
    /// Moves in physycal world the whole root node
    func setRootPosition(_ position: SCNVector3)
    /// Rotates whole plot
    func setRotation(x: Float?, y: Float?, z: Float?)
    /// Rotates whole plot
    func setRotation(_ rotation: SCNVector3)
    /// Resets the scale of the grid to its initial state. Doesn't change physical size of a node.
    func resetNodeScale(animationDuration: TimeInterval)
    func resetRotation(animationDuration: TimeInterval)
    func resetRootPosition(animationDuration: TimeInterval)
    func resetBounds(animationDuration: TimeInterval)
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

    func setBounds(_ bounds: ValuesBounds) {
        setBounds(x: bounds, y: bounds, z: bounds)
    }
    
    func setRootPosition(_ position: SCNVector3) {
        setRootPosition(x: position.x, y: position.y, z: position.z)
    }
    
    func setRotation(_ rotation: SCNVector3) {
        setRotation(x: rotation.x, y: rotation.y, z: rotation.z)
    }
}
