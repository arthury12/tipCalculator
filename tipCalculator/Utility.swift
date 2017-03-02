//
//  Utility.swift
//  tipCalculator
//
//  Created by Arthur Yu on 3/1/17.
//  Copyright © 2017 Arthur Yu. All rights reserved.
//

import Foundation

class Utility {
    
    func setUserDefault(key: String, value:String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func setUserDefault(key: String, value:TimeInterval) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
}
