//
//  LabelDeviceClass.swift
//  wazap
//
//  Created by 유호균 on 2016. 7. 1..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class UILabelDeviceClass : UILabel {
    
    @IBInspectable var iPhoneFontSize:CGFloat = 0 {
        didSet {
            overrideFontSize(iPhoneFontSize)
        }
    }
    
    func overrideFontSize(fontSize:CGFloat){
        let currentFontName = self.font.fontName
        var calculatedFont: UIFont?
        let bounds = UIScreen.mainScreen().bounds
        let height = bounds.size.height
        switch height {
        case 480.0: //Iphone 3,4,SE => 3.5 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.7)
            self.font = calculatedFont
            break
        case 568.0: //iphone 5, 5s => 4 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.8)
            self.font = calculatedFont
            break
        case 667.0: //iphone 6, 6s => 4.7 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize * 0.9)
            self.font = calculatedFont
            break
        case 736.0: //iphone 6s+ 6+ => 5.5 inch
            calculatedFont = UIFont(name: currentFontName, size: fontSize)
            self.font = calculatedFont
            break
        default:
            print("not an iPhone")
            break
        }
        
    }
    
}
