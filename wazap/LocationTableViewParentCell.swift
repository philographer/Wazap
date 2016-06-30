//
//  LocationTableViewParentCell.swift
//  wazap
//
//  Created by 유호균 on 2016. 6. 26..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class LocationTableViewParentCell: UITableViewCell {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
