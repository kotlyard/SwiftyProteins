//
//  SCNAtom.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 6/19/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import UIKit
import SceneKit

class SCNAtom: SCNNode {
    
    var atomName: String? = nil
    
    override init() {
        super.init()
        self.geometry = SCNSphere(radius: 0.001)
    }
    
    func draw(atom: Atom) {
        self.atomName = atom.name
        self.position = atom.coord
        self.position.x *= 0.025
        self.position.y *= 0.025
        self.position.z *= 0.025
        self.geometry?.firstMaterial?.diffuse.contents = AtomColoring.spkColoring(name: atom.name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
