//
//  MainTableViewCellController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var dueDay: UILabel!
    @IBOutlet weak var dueTime: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var tagList: UILabel!
    @IBOutlet weak var hostName: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
