//
//  NetworkController.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 5/31/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import Foundation
import Alamofire
import SceneKit


final class NetworkController {
    
    static func requestMolecule(with name: String, completion: @escaping (_ data: String) -> Void ) {
        let prefix = "http://files.rcsb.org/ligands/view/"
        let sufix = "_model.pdb"
        
        guard let url = URL(string: prefix + name + sufix) else { fatalError("Error creating link with name: \(prefix + name + sufix)") }
        
        request(url, method: .get).validate().responseString { response in
            switch response.result {
                case .success:
                    completion(response.value!)
                case .failure:
                    print(response.error ?? "error")
            }
        }
    }

    
    static func parseMolecule(with string: String) -> Molecule {
        let atomsStrings = string.components(separatedBy: CharacterSet.newlines).filter( {$0.hasPrefix("ATOM") })
        
        let connectionsStrings = string.components(separatedBy: CharacterSet.newlines).filter( { $0.hasPrefix("CONECT") })
        
    
        return parseAtoms(from: atomsStrings, and: connectionsStrings)

        
    }
    
    
    static func parseAtoms(from atomsStrings: [String], and connectionsStrings: [String]) -> Molecule {
		var molecule: Molecule? = nil
		var name = String()
        var atoms = [Atom]()

        for (index, element) in atomsStrings.enumerated() {
            let splitedAtomString = element.components(separatedBy: CharacterSet.whitespaces).filter( { !$0.isEmpty } )
            let coord = SCNVector3(x: Float(splitedAtomString[6])! * 0.1, y: Float(splitedAtomString[7])! * 0.1, z: Float(splitedAtomString[8])! * 0.1)
			atoms.append(Atom(coord: coord, id: UInt(index + 1), name: splitedAtomString.last!, label: splitedAtomString[2]))
			
			name = splitedAtomString[3]
        }
		
        let connections = parseConnections(from: connectionsStrings)
		molecule = Molecule(name: name, atoms: atoms, connections: connections)
		return molecule!
    }
    
    
    static func parseConnections(from strings: [String]) -> [(Int, Int)] {
        var res = [(Int, Int)]()

        for elem in strings {
			let line = elem.components(separatedBy: CharacterSet.whitespaces).filter( { !$0.isEmpty && $0 != "CONECT"} )
			for (index, elem) in line.enumerated() {
				if index == 0 { continue }
				res.append((Int(line[0]) ?? 0, Int(elem) ?? 0))
			}
        }
        print(res)
        return res
    }
}


