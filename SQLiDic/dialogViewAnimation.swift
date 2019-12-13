//
//  dialogViewAnimation.swift
//  SQLiDic
//
//  Created by Archylex on 27/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import Foundation
import UIKit

protocol dialogShowAnimation {
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var backgroundView:UIView {get}
    var dialogView:UIView {get set}
}

extension dialogShowAnimation where Self: UIView {    
    func show(animated:Bool) {        
        self.backgroundView.alpha = 0
        self.dialogView.center = CGPoint(x: self.center.x, y: self.center.y)
        self.dialogView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.dialogView.alpha = 0.0
        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = 0.66
        })
        
        UIView.animate(withDuration: 0.25, animations: {
            self.dialogView.alpha = 1.0
            self.dialogView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })        
    }
    
    func dismiss(animated:Bool) {        
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (completed) in
                
            })
            
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }        
    }
}