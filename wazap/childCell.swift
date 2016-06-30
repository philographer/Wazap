//
//  childCell.swift
//  wazap
//
//  Created by 유호균 on 2016. 3. 25..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class childCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var acceptButton: AcceptButton!
    @IBOutlet weak var centerYconstraint: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
