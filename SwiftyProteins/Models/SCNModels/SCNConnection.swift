//
//  AtomConnection.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 6/24/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import UIKit
import SceneKit
import GLKit

class SCNConnection: SCNNode {
    
    init (v1: SCNVector3, v2: SCNVector3) {
        super.init()
        let parentNode = SCNNode()
        let height = distance(v1: v1, v2: v2)
        
        self.position = v1
        let nodeV2 = SCNNode()
        nodeV2.position = v2
        parentNode.addChildNode(nodeV2)
        
        let layDown = SCNNode()
        layDown.eulerAngles.x = Float.pi / 2
        
        let cylinder = SCNCylinder(radius: 0.00035, height: CGFloat(height))
        cylinder.firstMaterial?.diffuse.contents = UIColor.white
        
        let nodeWithCylinder = SCNNode(geometry: cylinder)
        nodeWithCylinder.position.y = -height / 2
        layDown.addChildNode(nodeWithCylinder)
        
        self.addChildNode(layDown)
        self.constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func distance (v1: SCNVector3, v2: SCNVector3) -> Float {
        let first = SCNVector3ToGLKVector3(v1)
        let second = SCNVector3ToGLKVector3(v2)
        
        return GLKVector3Distance(first, second)
    }
}
