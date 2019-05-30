//
//  AuthViewController.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 5/28/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var mainSpinner: UIActivityIndicatorView!
    
    //actions
    @IBAction func loginTapped(_ sender: UIButton) {
        turnOffInterface()
        authWithBiometrics()
    }
    
    
    //variables
    
    
    
    //override functions
    
    override func viewDidLoad() {
        mainSpinner.stopAnimating()
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }

    
    func authWithBiometrics() {
        let context = LAContext()
        let reason = "Plese identify yourself to sign in Swifty Proteins"
        var error: NSError?
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                if success {
                    print("authenticate successfully")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toProteinsList", sender: nil)
                    }
                }
                else { print(error?.localizedDescription ?? "error") }
            })
        
        }
        else { showAlert(with: error?.localizedDescription ?? "error") }
    }
}

extension UIViewController {
    
    /// shows "Error" alert with msg given as argument
    func showAlert(with msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}



extension AuthViewController {
    func turnOnInterface() {
        DispatchQueue.main.async {
            self.mainSpinner.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.view.layer.opacity = 1
        }
        
    }
    
    func turnOffInterface() {
        DispatchQueue.main.async {
            self.mainSpinner.startAnimating()
            self.view.isUserInteractionEnabled = false
            self.view.layer.opacity = 0.6
        }
    }
}
