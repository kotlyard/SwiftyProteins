//
//  Alertlabel.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 7/12/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import Foundation
import UIKit

class AlertLabel: UILabel {
    
    override var text: String? {
        didSet {
            self.fadeViewInThenOut(view: self, delay: 2)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.myInit()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.myInit()
    }
    
    private func myInit() {
        self.font = UIFont(name: "Verdana", size: 20)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.textAlignment = .center
        self.numberOfLines = 2
    }
    
    
    private func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        
        let animationDuration = 0.5
        
        // Fade in the view
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseIn, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                view.alpha = 0
            })
        }
    }
}
