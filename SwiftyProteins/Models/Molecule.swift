//
//  Molecule.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 5/31/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import Foundation

struct Molecule {
    let name: String
    let atoms: [Atom]
    let connections: [(Int, Int)]
}
