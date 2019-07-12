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
	@IBOutlet weak var alertLabel: AlertLabel!

	
	let scene = SCNScene()
		
	var hydrogeneTextPresence = false
	

	var molecule: Molecule? = nil
    var atomNodes = [SCNAtom]()
	var hydrogeneConnectionNodes = [SCNNode]()
	var hydrogeneTextNodes = [SCNNode]()
    var textNodes = [SCNNode]()
    var moleculeNode = SCNNode()
	
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		alertLabel.text = "Long press anywhere to open settings"
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addObservers()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let molecule = molecule else { print("no molecule"); return }
		
		setUpScene()
		drawAtoms(with: molecule.atoms)
		drawConnections()
		if AppSettings.shared.hydrogenePresence == false { hydrogeneSwitch() }
		if AppSettings.shared.labelsPresence == true { labelsSwitch() }
	}
	
    internal func setUpScene() {
        SceneView.scene = scene
        scene.rootNode.addChildNode(moleculeNode)
    }
    
    
    internal func drawAtoms(with atoms: [Atom]) {
        for elem in atoms {
            let atomNode = SCNAtom()
            createTapGesture(for: atomNode)
            atomNode.draw(atom: elem)
            atomNodes.append(atomNode)
            drawAtomText(atom: elem)
            moleculeNode.addChildNode(atomNode)
			print(atomNode.position, atomNode.worldPosition)
        }
	}
		
	internal func drawConnections() {
		guard let count = molecule?.atoms.count else { print("error getting atoms count"); return }
		
		for elem in molecule!.connections {
			if (elem.0 <= count && elem.1 <= count)
			{
				let connect = SCNConnection(v1: atomNodes[elem.0 - 1].position , v2: atomNodes[elem.1 - 1].position)
				if atomNodes[elem.0 - 1].atomName == "H" || atomNodes[elem.1 - 1].atomName == "H" {
					hydrogeneConnectionNodes.append(connect)
				}
				moleculeNode.addChildNode(connect)
			}
		}
	}
	

	
	internal func drawAtomText(atom: Atom) {
		let textGeometry = SCNText(string: atom.label, extrusionDepth: 0.1)
		textGeometry.firstMaterial?.diffuse.contents = UIColor.black
		textGeometry.font = UIFont(name: "Helvetica", size: 0.6)
		
		//Settig positioin
		let textNode = SCNNode(geometry: textGeometry)
		textNode.position = SCNVector3(atom.coord.x * 0.025, atom.coord.y * 0.025, atom.coord.z * 0.025)
		textNode.scale = SCNVector3Make(0.0015, 0.0015, 0.0015)
		print("textNode \(textNode.position)")
		
		// LOCKING LABEL AT CAMERA
		textNode.constraints = [SCNBillboardConstraint()]
		if atom.name == "H" {
			hydrogeneTextNodes.append(textNode)
		} else {
			textNodes.append(textNode)
		}
	}

	
    internal func createTapGesture(for atom: SCNAtom) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        SceneView.addGestureRecognizer(tap)
    }
    
    @objc internal func handleTap(rec: UITapGestureRecognizer) {
        if rec.state == .ended {
            let location = rec.location(in: SceneView)
            let hits = SceneView.hitTest(location, options: nil)
            if let tappedNode = hits.first?.node as? SCNAtom {
				print(tappedNode.atomName ?? "sas")
				alertLabel.text = tappedNode.atomName
				if let color =  tappedNode.geometry?.firstMaterial?.diffuse.contents as? UIColor {
					alertLabel.textColor = color
				}
				
            }
        }
    }
	
	@objc internal func hydrogeneSwitch() {
		if AppSettings.shared.hydrogenePresence {
			AppSettings.shared.hydrogenePresence = false
			hydrogeneTextPresence = false
			hydrogeneTextNodes.forEach({ $0.removeFromParentNode() })
			hydrogeneConnectionNodes.forEach( { $0.removeFromParentNode() } )
			atomNodes.forEach( { if $0.atomName == "H" { $0.removeFromParentNode()} } )
			
		} else {
			AppSettings.shared.hydrogenePresence = true
			hydrogeneConnectionNodes.forEach( { self.scene.rootNode.addChildNode($0) } )
			if 	hydrogeneTextPresence == false && AppSettings.shared.labelsPresence {
				hydrogeneTextNodes.forEach({ moleculeNode.addChildNode($0) })
			}
			atomNodes.forEach( { if $0.atomName == "H" { scene.rootNode.addChildNode($0)} } )
		}
	}

	@objc internal func labelsSwitch() {
		if AppSettings.shared.labelsPresence {
			AppSettings.shared.labelsPresence = !AppSettings.shared.labelsPresence
			textNodes.forEach({ $0.removeFromParentNode() })
			hydrogeneTextNodes.forEach({ $0.removeFromParentNode() })
			hydrogeneTextPresence = false
		} else {
			AppSettings.shared.labelsPresence = !AppSettings.shared.labelsPresence
			if 	AppSettings.shared.hydrogenePresence == true {
				hydrogeneTextNodes.forEach({ moleculeNode.addChildNode($0) })
				hydrogeneTextPresence = true
			}
			textNodes.forEach({ moleculeNode.addChildNode($0) })
		}
	}
	
	deinit {
		removeObservers()
	}
	
}



// - MARK:ACTIONS
extension ProteinModelViewController {
	
    @IBAction func shareTapped(_ sender: Any) {
        let image = SceneView.snapshot()
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
	
	@IBAction func showSettings(_ sender: Any) {
		if presentedViewController is SettingsViewController { return }
		performSegue(withIdentifier: "showSettings", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toARModel" {
			if let destVC = segue.destination as? ArModelViewController {
				destVC.molecule = self.molecule
				destVC.title = self.title
			} else { print("Error extracting destVC") }
		}
	}
}

extension ProteinModelViewController {

	internal func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(hydrogeneSwitch), name: Notification.Name("hydrogeneSwitch"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(labelsSwitch), name: Notification.Name("labelsSwitch"), object: nil)
	}

	internal func removeObservers() {
		NotificationCenter.default.removeObserver(self, name: Notification.Name("hydrogeneSwitch"), object: nil)
		NotificationCenter.default.removeObserver(self, name: Notification.Name("labelsSwitch"), object: nil)
	
	}

}

//418,PYB, K7J, UNK, BV1, IMT
