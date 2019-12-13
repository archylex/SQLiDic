//
//  defaultOrMemory.swift
//  SQLiDic
//
//  Created by Archylex on 27/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import Foundation
import UIKit

func defaultOrMemory (key: String, center: String) -> String {    
    if UserDefaults.standard.object(forKey: key) == nil {
        UserDefaults.standard.set(center, forKey: key)
        return center
    } else {
        return UserDefaults.standard.object(forKey: key) as! String
    }    
}

func defaultOrMemory (key: String, center: CGFloat) -> CGFloat {    
    if UserDefaults.standard.object(forKey: key) == nil {
        UserDefaults.standard.set("\(center)", forKey: key)
        return center
    } else {
        guard let n = NumberFormatter().number(from: UserDefaults.standard.object(forKey: key) as! String) else { return center}
        return CGFloat(truncating: n)
    }    
}

func defaultOrMemory (key: String, center: Int) -> Int {    
    if UserDefaults.standard.object(forKey: key) == nil {
        UserDefaults.standard.set("\(center)", forKey: key)
        return center
    } else {
        guard let n = NumberFormatter().number(from: UserDefaults.standard.object(forKey: key) as! String) else { return center}
        return Int(truncating: n)
    }    
}

func defaultOrMemory (key: String, center: String, alpha: CGFloat) -> UIColor {    
    if UserDefaults.standard.object(forKey: key) == nil {
        UserDefaults.standard.set(center, forKey: key)
        return hexToUIColor(hex: center, alfa: alpha)
    } else {
        return hexToUIColor(hex: UserDefaults.standard.object(forKey: key) as! String, alfa: alpha)
    }    
}