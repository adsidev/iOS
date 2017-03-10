//
//  Utility.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 04/03/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation

class Utility {
    
    class func set(streak: Int)  {
        let userDefaults = UserDefaults.standard
        userDefaults.set(streak, forKey: "streak")
        
    }
    
    class func getStreak() -> Int  {
        let userDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: "streak")
    }
    
}
