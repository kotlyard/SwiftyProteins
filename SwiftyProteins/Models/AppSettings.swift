//
//  AppSettings.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 7/11/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import Foundation

final class AppSettings {
    
    public static let shared = AppSettings()
    private init() {}
    
    internal var hydrogenePresence: Bool = true
    internal var labelsPresence: Bool = false
}
