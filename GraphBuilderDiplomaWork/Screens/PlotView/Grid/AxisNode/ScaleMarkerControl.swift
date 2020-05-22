//
//  ScaleMarkerControl.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


class ScaleMarkerControl {
    
    
    // MARK: - Properties
    
    let node: SCNNode
    let textNode = SCNNode()
    
    
    // MARK: - Initialization
    
    init(node: SCNNode) {
        self.node = node
        setupTextNode()
    }
    
    
    // MARK: - Setup Methods
    
    private func setupTextNode() {
        node.addChildNode(textNode)
        textNode.scale = SCNVector3(0.009)
        setTextValue(0)
    }
    
    
    
    // MARK: - API Methods
    
    func setTextValue(_ value: Double) {
        let text: String
        if Double(Int(value)) == value {
            text = String(Int(value))
        } else {
            text = String(value.rounded(toPlaces: 2))
        }
        let textGeometry = SCNText(string: text, extrusionDepth: 0.2)
        textGeometry.firstMaterial?.diffuse.contents = Color.defaultText()
        textNode.geometry = textGeometry
        
    }
    
}
