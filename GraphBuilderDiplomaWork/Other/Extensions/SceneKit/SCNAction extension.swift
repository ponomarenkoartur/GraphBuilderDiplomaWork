//
//  SCNAction extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 13.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


extension SCNAction {
    class func scale(to targetScale: SCNVector3, duration: TimeInterval) -> SCNAction {
        var initialScale: SCNVector3!
        var delta: SCNVector3!
        var tanAlpha: SCNVector3!
        
        return SCNAction.customAction(duration: duration) { (node, time) in
            if initialScale == nil {
                initialScale = node.scale
                delta = targetScale - initialScale
                tanAlpha = Float(duration) / delta
            }
            
            node.scale = (Float(time) / tanAlpha) + initialScale
        }
    }
}
