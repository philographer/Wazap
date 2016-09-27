//
//  Border.swift
//  wazap
//
//  Created by 유호균 on 2016. 6. 16..
//  Copyright © 2016년 nexters. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, radius: CGFloat = 0) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(0, 0, self.frame.size.width, thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, self.frame.size.width, thickness)
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(0, 0, thickness, self.frame.size.height)
            break
        case UIRectEdge.Right:
            
            if(UIScreen.mainScreen().bounds.width / 2 < self.frame.size.width - thickness){
            border.frame = CGRectMake(self.frame.size.width - thickness, 0, thickness, self.frame.size.height)
            }
            
            break
        default:
            break
        }
        
        border.backgroundColor = color.CGColor;
        border.cornerRadius = radius
        
        self.addSublayer(border)
    }
    
}

