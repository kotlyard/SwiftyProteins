//
//  ProteinModelViewController.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 5/31/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import UIKit
import SceneKit


class ProteinModelViewController: UIViewController {
   @IBOutlet weak var SceneView: SCNView!
	
    
    let scene = SCNScene()
    let cameraNode = SCNNode()
	
	var molecule: Molecule? = nil
	
    var atomNodes = [SCNAtom]()
	var connectionNodes = [SCNConnection]()
    var textNodes = [SCNNode]()
    let moleculeNode = SCNNode()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		guard let _ = molecule else { fatalError("no molecule") }
        setUpScene()
		drawAtoms(with: molecule!.atoms)
		drawConnections()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    
    private func setUpScene() {
        SceneView.scene = scene
        scene.rootNode.addChildNode(moleculeNode)
    }
    
    
    private func drawAtoms(with atoms: [Atom]) {
        for elem in atoms {
            let atomNode = SCNAtom()
            createTapGesture(for: atomNode)
            atomNode.draw(atom: elem)
            atomNodes.append(atomNode)
            drawAtomText(atom: elem)
            moleculeNode.addChildNode(atomNode)
        }
	}
		
		private func drawConnections() {
			for elem in molecule!.connections {
				if (elem.0 <= (molecule?.atoms.count)! && elem.1 <= (molecule?.atoms.count)!)
				{
					let connect = SCNConnection(v1: atomNodes[elem.0 - 1].position , v2: atomNodes[elem.1 - 1].position)
					moleculeNode.addChildNode(connect)
				}
			}
		}
	
	private func drawAtomText(atom: Atom) {
		let geo = SCNText(string: atom.label, extrusionDepth: 0.1)
		geo.firstMaterial?.diffuse.contents = UIColor.black
		geo.font = UIFont(name: "Helvetica", size: 1.4)
		
		//Settig positioin
		let textNode = SCNNode(geometry: geo)
		textNode.worldPosition = SCNVector3(atom.coord.x, atom.coord.y, atom.coord.z + 0.01)
		textNode.scale = SCNVector3Make(0.03, 0.03, 0.03)
		
		// LOCKING LABEL AT CAMERA
		textNode.constraints = [SCNBillboardConstraint()]
		
		textNodes.append(textNode)
	}
	
    private func createTapGesture(for atom: SCNAtom) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        SceneView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(rec: UITapGestureRecognizer) {
        if rec.state == .ended {
            let location = rec.location(in: SceneView)
            let hits = SceneView.hitTest(location, options: nil)
            if let tappedNode = hits.first?.node as? SCNAtom {
				print(tappedNode.atomName ?? "sas")
            }
        }
    }
    
    
	
    
}


// - MARK:ACTIONS
extension ProteinModelViewController {
	
    @IBAction func shareTapped(_ sender: Any) {
        let image = SceneView.snapshot()
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
	
    @IBAction func showHideLabels(_ sender: UIButton) {
        if moleculeNode.childNodes.contains(textNodes.first!) {
            for elem in textNodes {
				elem.removeFromParentNode()
            }
        } else {
            for elem in textNodes {
                moleculeNode.addChildNode(elem)
            }
        }
    }
	
	@IBAction func changeFontSize(_ sender: UIButton) {
		if sender.tag == 0 {
			
		} else {
			
		}
	}
}

//418,PYB, K7J,
