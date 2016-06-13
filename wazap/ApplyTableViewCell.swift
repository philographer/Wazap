//
//  ApplyTableViewCell.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 26..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class ApplyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recruitLabel: UILabel!
    @IBOutlet weak var applierLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet var cancleButton: UIButton!
    @IBOutlet weak var endImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
