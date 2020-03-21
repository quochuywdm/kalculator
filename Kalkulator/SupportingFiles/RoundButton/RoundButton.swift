//
//  RoundButton.swift
//  Kalkulator
//
//  Created by Nguyễn Quốc Huy on 21.03.20.
//  Copyright © 2020 Nguyễn Quốc Huy. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCR(_value: cornerRadius)
        }
    }
    
    func refreshCR(_value: CGFloat) {
        layer.cornerRadius = _value
    }
    
    @IBInspectable var customBGColor: UIColor = UIColor.init(red: 0, green: 122/255, blue: 255/255, alpha: 1) {
        didSet {
            refreshColor(_color: customBGColor)
        }
    }
    
    func refreshColor(_color: UIColor) {
        let size: CGSize = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        _color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let bgImage: UIImage = (UIGraphicsGetImageFromCurrentImageContext() as UIImage?)!
        UIGraphicsEndImageContext()
        setBackgroundImage(bgImage, for: UIControl.State.normal)
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCR(_value: cornerRadius)
        refreshColor(_color: customBGColor)
        self.tintColor = UIColor.white
    }
}

