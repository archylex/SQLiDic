//
//  inputTableViewCell.swift
//  SQliDic
//
//  Created by Archylex on 23/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import UIKit

protocol inputTableViewCellDelegate {
    func searchButtonPressed(_ header: inputTableViewCell)
}

class inputTableViewCell: UITableViewCell, UITextFieldDelegate {    
    var delegate: inputTableViewCellDelegate?    
    var searchButton = UIButton()
    var searchField: SearchTextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = defaultOrMemory(key: "MainHeaderColor", center: "#2E3944", alpha: 1.0)
        contentView.clipsToBounds = true
        
        let myWidth = UIScreen.main.bounds.size.width
                
        let acMax: Int = defaultOrMemory(key: "AutoCompleteMaximum", center: 15)
        searchField = SearchTextField(frame: CGRect(x: 10, y: 10, width: myWidth - 100, height: 22))
        searchField.textColor = defaultOrMemory(key: "SearchFieldFontColor", center: "#000000", alpha: 1.0)
        searchField.backgroundColor = defaultOrMemory(key: "SearchFieldColor", center: "#FFFFFF", alpha: 1.0)
        searchField.layer.cornerRadius = 10
        searchField.textAlignment = NSTextAlignment.center
        searchField.maxNumberOfResults = acMax
        searchField.maxResultsListHeight = 150
        searchField.minCharactersNumberToStartFiltering = 1
        searchField.theme.borderColor = hexToUIColor(hex: "#FFFFFF", alfa: 0.9)
        searchField.theme.font = UIFont.systemFont(ofSize: defaultOrMemory(key: "AutoCompleteFontSize", center: 16))
        searchField.theme.bgColor = defaultOrMemory(key: "AutoCompleteColor", center: "#2E3944", alpha: 0.7)
        searchField.theme.bgColor = defaultOrMemory(key: "AutoCompleteFontColor", center: "#FFFFFF", alpha: 0.9)
        searchField.theme.cellHeight = 42
        searchField.userStoppedTypingHandler = {
            if let criteria = self.searchField.text {
                if criteria.characters.count > 1 {                    
                    var mtrs = RegularExpression(for: "[\u{4E00}-\u{9FAF}]", in: self.searchField.text!)
                    if !mtrs.isEmpty {
                        self.searchField.filterStrings(SearchingDataProcess(text: criteria, numRow: 1, count: acMax))
                    } else {
                        mtrs = RegularExpression(for: "[\u{3040}-\u{309F}\u{30A0}-\u{30FF}]", in: self.searchField.text!)
                        if !mtrs.isEmpty {
                            self.searchField.filterStrings(SearchingDataProcess(text: criteria, numRow: 2, count: acMax))
                        }
                    }
                }
            }
        }
        searchField.delegate = self
        contentView.addSubview(searchField)
                
        searchButton = UIButton(frame: CGRect(x: myWidth - 80, y: 10, width: 70, height: 22))
        searchButton.setTitle("  Search  ", for: .normal)
        searchButton.setTitleColor(defaultOrMemory(key: "ButtonFontColor", center: "#000000", alpha: 1.0), for: .normal)
        searchButton.backgroundColor = defaultOrMemory(key: "ButtonColor", center: "#FFFFFF", alpha: 1.0)
        searchButton.layer.cornerRadius = 10
        searchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        searchButton.titleLabel?.numberOfLines = 1
        searchButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        contentView.addSubview(searchButton)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UserDefaults.standard.set(searchField.text, forKey: "searchQuery")
        delegate?.searchButtonPressed(self)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inputTableViewCell.itsRuningNow(_:))))
        return true
    }    
    
    @objc func buttonAction(sender: UIButton!) {
        UserDefaults.standard.set(searchField.text, forKey: "searchQuery")
        delegate?.searchButtonPressed(self)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inputTableViewCell.itsRuningNow(_:))))        
    }
        
    @objc func itsRuningNow(_ gestureRecognizer: UITapGestureRecognizer) {
        guard (gestureRecognizer.view as? inputTableViewCell) != nil else {
            return
        }
        
        delegate?.searchButtonPressed(self)
    }    
}