//
//  NotificationTableViewCell.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 22..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    /**
     @ Outlet
    */
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var alarmTextView: UITextView!
    @IBOutlet weak var beforeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
