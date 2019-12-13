//
//  CustomAlert.swift
//  SQliDic
//
//  Created by Archylex on 25/01/2018.
//  Copyright © 2018 Archylex. All rights reserved.
//

import UIKit
import Foundation

protocol customAlertDelegate {
    func okButtonPressed(_ header: CustomAlert)
}

class CustomAlert: UIView, dialogShowAnimation {    
    var backgroundView = UIView()
    var dialogView = UIView()
    var pubTitle = String()
    var textField = UITextField()
    var field = String()
    open var delegate: customAlertDelegate?
    
    convenience init(title: String, field: String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title, field: field)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(title: String, field: String) {        
        dialogView.clipsToBounds = true

        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-64
        var newHeight = CGFloat()
        let elHeight: CGFloat = 20
        let myHeight: CGFloat = 30
        let titleLabel = UILabel(frame: CGRect(x: 30, y: 8, width: dialogViewWidth - 60, height: myHeight))
        
        titleLabel.text = title
        pubTitle = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.layer.cornerRadius = 10
        dialogView.addSubview(titleLabel)
        
        newHeight = newHeight + titleLabel.frame.height + elHeight
        
        if field == "text" {
            // Text Field
            textField = UITextField(frame: CGRect(x: 30, y: newHeight, width: dialogViewWidth - 60, height: myHeight))
            textField.backgroundColor = UIColor.white
            textField.layer.cornerRadius = 10
            textField.textAlignment = .center
            newHeight = newHeight + textField.frame.height + elHeight
            dialogView.addSubview(textField)
            
            // Button 'OK'
            let okButton = UIButton(frame: CGRect(x: dialogViewWidth/2 - 40, y: newHeight, width: 80, height: myHeight))
            okButton.setTitle("OK", for: .normal)
            okButton.setTitleColor(UIColor.black, for: .normal)
            okButton.backgroundColor = UIColor.white
            okButton.layer.cornerRadius = 10
            okButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            dialogView.addSubview(okButton)
        }
        
        
        if field == "color" {        
            let pickerSize = CGSize(width: dialogViewWidth - 50, height: dialogViewWidth - 50)
            let pickerOrigin = CGPoint(x: 30, y: newHeight - 10)
                        
            var colorPicker: ChromaColorPicker!
            colorPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
            colorPicker.delegate = self as! ChromaColorPickerDelegate
                        
            colorPicker.padding = 10
            colorPicker.stroke = 3 
            colorPicker.currentAngle = Float.pi            
            
            colorPicker.supportsShadesOfGray = true 
            colorPicker.hexLabel.textColor = UIColor.white
            
            dialogView.addSubview(colorPicker)
        }
        
        let dialogViewHeight = dialogViewWidth
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.clear
        dialogView.layer.cornerRadius = 10
        addSubview(dialogView)
    }
    
    @objc func buttonAction(sender: UIButton!) {        
        let srcText = textField.text as! String
        let dig = RegularExpression(for: "^\\d+$", in: srcText)
        
        if (!pubTitle.isEmpty && !dig.isEmpty) {            
            let key = pubTitle.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            
            UserDefaults.standard.set(srcText, forKey: key)
            delegate?.okButtonPressed(self)
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CustomAlert.tapHeader(_:))))            
        }
        
        dismiss(animated: true)        
    }
        
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {        
        guard let cell = gestureRecognizer.view as? CustomAlert else {
            return
        }
        
        delegate?.okButtonPressed(self)
    }
}

extension CustomAlert: ChromaColorPickerDelegate{
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {        
        let key = pubTitle.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        UserDefaults.standard.set(color.hexCode, forKey: key)
        delegate?.okButtonPressed(self)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CustomAlert.tapHeader(_:))))
        dismiss(animated: true)        
    }
}