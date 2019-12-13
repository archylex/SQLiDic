//
//  searchTableViewCell.swift
//  SQliDic
//
//  Created by Archylex on 22/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import UIKit

class searchTableViewCell: UITableViewCell {    
    var kanjiLabel = UILabel()
    var kanaLabel = UILabel()
    var translateLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        self.backgroundColor = UIColor.clear            
            
        contentView.addSubview(kanjiLabel)
        kanjiLabel.translatesAutoresizingMaskIntoConstraints = false
        kanjiLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        kanjiLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5).isActive = true
        kanjiLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        kanjiLabel.numberOfLines = 0
        kanjiLabel.font = UIFont.systemFont(ofSize: defaultOrMemory(key: "KanjiFontSize", center: 16))
        kanjiLabel.textColor = defaultOrMemory(key: "KanjiFontColor", center: "BB0000", alpha: 1.0)
            
        contentView.addSubview(kanaLabel)
        kanaLabel.translatesAutoresizingMaskIntoConstraints = false
        kanaLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        kanaLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        kanaLabel.topAnchor.constraint(equalTo: kanjiLabel.bottomAnchor, constant: 5).isActive = true
        kanaLabel.numberOfLines = 0
        kanaLabel.font = UIFont.systemFont(ofSize: defaultOrMemory(key: "KanaFontSize", center: 16))
        kanaLabel.textColor = defaultOrMemory(key: "KanaFontColor", center: "3333FF", alpha: 1.0)
            
        contentView.addSubview(translateLabel)
        translateLabel.translatesAutoresizingMaskIntoConstraints = false
        translateLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        translateLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        translateLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        translateLabel.topAnchor.constraint(equalTo: kanaLabel.bottomAnchor, constant: 5).isActive = true
        translateLabel.numberOfLines = 0
        translateLabel.font = UIFont.systemFont(ofSize: defaultOrMemory(key: "TranslateFontSize", center: 16))
        translateLabel.textColor = defaultOrMemory(key: "TranslateFontColor", center: "555555", alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}