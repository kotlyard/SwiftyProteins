//
//  Atom.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 5/31/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import Foundation
import SceneKit


struct Atom {
    let coord: SCNVector3
    let id: UInt
    let name: String
    let label: String

    
    var description: String {
        return "\(id)       \(coord)       (\(name)))"
    }
}
