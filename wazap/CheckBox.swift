//
//  CheckBox.swift
//  Flyerszone
//
//  Created by 맥북 on 2016. 5. 26..
//  Copyright © 2016년 맥북. All rights reserved.
//

import UIKit

class CheckBox: UIButton{
    // Images
    var checkedImage = UIImage()
    var uncheckedImage = UIImage()
    
    func setImage(checked : String, unchecked : String){
        checkedImage = UIImage(named: checked)!
        uncheckedImage = UIImage(named: unchecked)!
        self.uncheck()
        self.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    convenience init(){
        self.init()
        self.setTitle("", forState: .Normal)
        self.backgroundColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
                self.setTitleColor(UIColorFromRGB(0x0358FF), forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
                self.setTitleColor(UIColorFromRGB(0xD7D7D7), forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(self.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
    func check(){
        self.setImage(checkedImage, forState: .Normal)
    }
    func uncheck(){
        self.setImage(uncheckedImage, forState: .Normal)
    }
}

/*
 @IBOutlet weak var adIdeaMarketingButton: UIButton!
 @IBOutlet weak var designButton: UIButton!
 @IBOutlet weak var picUccButton: UIButton!
 @IBOutlet weak var gameSoftwareButton: UIButton!
 @IBOutlet weak var foreignButton: UIButton!
 @IBOutlet weak var etcButton: UIButton!
 */