//
//  SettingsViewController.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 7/11/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var hydrogeneSwitch: UISwitch!
    @IBOutlet weak var labelsSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(AppSettings.shared.hydrogenePresence)
        print(AppSettings.shared.labelsPresence)
        hydrogeneSwitch.setOn(AppSettings.shared.hydrogenePresence ? true : false, animated: false)
        labelsSwitch.setOn(AppSettings.shared.labelsPresence ? true : false, animated: false)
    }
    
    
    @IBAction func hydrogeneSwitchTapped() {
        NotificationCenter.default.post(name: Notification.Name("hydrogeneSwitch"), object: nil)
    }
    
    @IBAction func labelsSwitchTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("labelsSwitch"), object: nil)
    }
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true)
    }
    
}
