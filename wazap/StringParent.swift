//
//  Parent.swift
//  AccordionTableSwift
//
//  Created by Victor Sigler on 3/5/16.
//  Copyright © 2016 Pentlab. All rights reserved.
//

import Foundation
struct StringParent {
    
    /// State of the cell
    var state: State
    
    /// The childs of the cell
    var childs: [String]
    
    /// The title for the cell.
    var parentData: String
    
}

/**
 Overload for the operator != for tuples
 
 - parameter lhs: The first tuple to compare
 - parameter rhs: The seconde tuple to compare
 
 - returns: true if there are different, otherwise false
 */
func != (lhs: (Int, Int), rhs: (Int, Int)) -> Bool {
    return lhs.0 != rhs.0 && rhs.1 != lhs.1
}
