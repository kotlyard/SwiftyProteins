//
//  ARProteinModelViewController.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 7/4/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import Foundation
import ARKit
import SceneKit


final class ArModelViewController: ProteinModelViewController {
    
    @IBOutlet weak var ARSceneView: ARSCNView!
    @IBOutlet weak var alert: AlertLabel!
    
    var planeGeometry = SCNPlane()
    var anchors = [ARAnchor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setUpScene()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ARSceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        alert.text = "Long press anywhere to open settings"
    }
    
    override func setUpScene() {
        ARSceneView.scene = scene
        ARSceneView.showsStatistics = true
        ARSceneView.debugOptions = [.showWorldOrigin]
        if #available(iOS 12.0, *) {
            let config = ARWorldTrackingConfiguration()
            config.planeDetection = .horizontal
            config.isLightEstimationEnabled = true
            ARSceneView.session.run(config)
        } else {
            alert.text = "Your device is shit, sorry for that"
            return()
        }
        ARSceneView.scene.rootNode.addChildNode(self.moleculeNode)
    }


    override func createTapGesture(for atom: SCNAtom) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        ARSceneView.addGestureRecognizer(tap)
    }
    
    @objc override func handleTap(rec: UITapGestureRecognizer) {
        if rec.state == .ended {
            let location = rec.location(in: SceneView)
            let hits = ARSceneView.hitTest(location, options: nil)
            if let tappedNode = hits.first?.node as? SCNAtom {
                print(tappedNode.atomName ?? "sas")
                alert.text = tappedNode.atomName
                if let color =  tappedNode.geometry?.firstMaterial?.diffuse.contents as? UIColor {
                    alert.textColor = color
                }
            }
        }
    }
    
    @IBAction override func shareTapped(_ sender: Any) {
        let image = ARSceneView.snapshot()
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
}



//extension ArModelViewController: ARSCNViewDelegate {
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let location = touch?.location(in: ARSceneView)
//
//        addNodeAtLocation(location: location!)
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        var node: SCNNode? = nil
//
//        if let planeAnchor = anchor as? ARPlaneAnchor {
//            node = SCNNode()
//            planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//            planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.7)
//
//            let planeNode = SCNNode(geometry: planeGeometry)
//            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
//            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
//
//            updateMaterial()
//            node?.addChildNode(planeNode)
//            anchors.append(planeAnchor)
//        }
//
//        return node
//    }
//
//
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        if let planeAnchor = anchor as? ARPlaneAnchor {
//            if anchors.contains(planeAnchor) {
//                if node.childNodes.count > 0 {
//                    let planeNode = node.childNodes.first!
//                    planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
//
//                    if let plane = planeNode.geometry as? SCNPlane {
//                        plane.width = CGFloat(planeAnchor.extent.x * 0.5)
//                        plane.height = CGFloat(planeAnchor.extent.z * 0.5)
//                    }
//                }
//            }
//        }
//    }
//
//
//
//    func updateMaterial() {
//        self.planeGeometry.materials.first!.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeometry.width), Float(self.planeGeometry.height), 1)
//    }
//
//
//    func addNodeAtLocation(location: CGPoint) {
//        guard anchors.count > 0 else { print("anchros are not created yet"); return }
//
//        let hitResults = ARSceneView.hitTest(location, types: .existingPlaneUsingExtent)
//
//        if hitResults.count > 0 {
//            let result = hitResults.first!
//            let newLocation = SCNVector3(x: result.worldTransform.columns.3.x, y: result.worldTransform.columns.3.y, z: result.worldTransform.columns.3.z)
//
////            moleculeNode.presentation.position = newLocation
//
//            print(newLocation)
//            ARSceneView.scene.rootNode.addChildNode(moleculeNode)
//        }
//
//
//    }
//
//}













