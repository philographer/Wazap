//
//  parentCell.swift
//  wazap
//
//  Created by 유호균 on 2016. 3. 25..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class parentCell: UITableViewCell {

    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var contestTitle: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var applierListButton: UILabel!
    @IBOutlet weak var recruitLabel: UILabel!
    @IBOutlet weak var applierLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
