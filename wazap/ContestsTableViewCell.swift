//
//  ContestsTableViewCell.swift
//  wazap
//
//  Created by 유호균 on 2016. 3. 22..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class ContestsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var contestImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
