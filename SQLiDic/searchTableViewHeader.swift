//
//  searchTableViewHeader.swift
//  SQliDic
//
//  Created by Archylex on 22/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import UIKit

protocol searchTableViewHeaderDelegate {
    func toggleSection(_ header: searchTableViewHeader, section: Int)
}

class searchTableViewHeader: UITableViewHeaderFooterView {    
    var delegate: searchTableViewHeaderDelegate?
    var section: Int = 0
    
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.backgroundColor = defaultOrMemory(key: "HeaderColor", center: "2E3944", alpha: 1.0)
                
        contentView.addSubview(arrowLabel)
        arrowLabel.textColor = defaultOrMemory(key: "HeaderFontColor", center: "FFFFFF", alpha: 1.0)
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        contentView.addSubview(titleLabel)
        titleLabel.textColor = defaultOrMemory(key: "HeaderFontColor", center: "FFFFFF", alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchTableViewHeader.tapHeader(_:))))    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {        
        guard let cell = gestureRecognizer.view as? searchTableViewHeader else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)    
    }
    
    func setCollapsed(_ collapsed: Bool) {     
        arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)        
    }    
}

extension UIView {    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
         
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
         
        self.layer.add(animation, forKey: nil)        
    }    
}