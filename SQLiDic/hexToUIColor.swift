//
//  hexToUIColor.swift
//  SQliDic
//
//  Created by Archylex on 22/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import UIKit

func hexToUIColor (hex:String, alfa:CGFloat) -> UIColor {    
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    var rgbValue:UInt32 = 0
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: alfa
    )
}