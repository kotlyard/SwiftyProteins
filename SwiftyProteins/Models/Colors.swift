//
//  CPKColors.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 5/31/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import Foundation
import UIKit


struct AtomColoring {

    static func spkColoring(name: String) -> UIColor {
        switch name.lowercased() {
        case "h":
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        case "c":
            return UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        case "n":
            return UIColor(red: 37/255, green: 51/255, blue: 245/255, alpha: 1)
        case "o":
            return UIColor(red: 234/255, green: 62/255, blue: 37/255, alpha: 1)
        case "f", "cl" :
            return UIColor(red: 113/255, green: 236/255, blue: 78/255, alpha: 1)
        case "br":
            return UIColor(red: 141/255, green: 45/255, blue: 19/255, alpha: 1)
        case "i":
            return UIColor(red: 93/255, green: 14/255, blue: 180/255, alpha: 1)
        case "he", "ne", "ar", "xe", "kr":
            return UIColor(red: 117/255, green: 251/255, blue: 253/255, alpha: 1)
        case "p":
            return UIColor(red: 240/255, green: 158/255, blue: 57/255, alpha: 1)
        case "s":
            return UIColor(red: 251/255, green: 230/255, blue: 84/255, alpha: 1)
        case "b":
            return UIColor(red: 243/255, green: 174/255, blue: 128/255, alpha: 1)
        case "li", "na", "k", "rb", "cs", "fr":
            return UIColor(red: 108/255, green: 18/255, blue: 245/255, alpha: 1)
        case "be", "mg", "ca", "sr", "ba", "ra":
            return UIColor(red: 51/255, green: 117/255, blue: 31/255, alpha: 1)
        case "ti":
            return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        case "fe":
            return UIColor(red: 207/255, green: 124/255, blue: 45/255, alpha: 1)
        default:
            return UIColor(red: 208/255, green: 124/255, blue: 248/255, alpha: 1)
        }
    }
    
    
}




