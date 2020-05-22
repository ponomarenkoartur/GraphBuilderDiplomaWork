//
//  AxisNodeFabric.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 14.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


class AxisNodeFabric {
    
    
    // MARK: - API Methods
    
    func create(from node: SCNNode) -> AxisNode? {
        guard
            let cylinder = node.childNode(withName: "cylinder",
                                          recursively: true),
            let cone = node.childNode(withName: "cone", recursively: true),
            let scaleMarkersContainer =
                node.childNode(withName: "scale markers", recursively: true),
            let _ = cylinder.geometry as? SCNCylinder,
            let _ = cone.geometry as? SCNCone else {
                return nil
        }
        
        let scaleMarkers = scaleMarkersContainer.childNodes
        let axisNode = AxisNode(cylinder: cylinder, coneArrow: cone,
                                scaleMarkers: scaleMarkers)
        axisNode.addChildNode(node)
        
        return axisNode
    }
    
}
