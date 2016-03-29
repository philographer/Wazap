//
//  ScrapTableViewCell.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 25..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class ScrapTableViewCell: UITableViewCell {

    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var recruitLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    //@IBOutlet weak var detailButton: UIButton!
    //@IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
