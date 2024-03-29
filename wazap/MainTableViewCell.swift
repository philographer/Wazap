//
//  MainTableViewCellController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleTitle: UILabel! //제목
    @IBOutlet weak var day: UILabel! //마감일
    @IBOutlet weak var dueDay: UILabel! //D-Day
    @IBOutlet weak var tagList: UILabel! //태그 리스트
    @IBOutlet weak var hostName: UILabel! //주최자
    @IBOutlet weak var scrapButton: UIButton! //스크랩버튼
    @IBOutlet weak var nowNumber: UILabel!
    @IBOutlet weak var maxNumber: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var contTitle: UILabel!
    @IBOutlet weak var contIcon: UIImageView!
    @IBOutlet weak var firstCategoryIcon: UIImageView!
    @IBOutlet weak var firstCategoryLabel: UILabel!
    @IBOutlet weak var secondCategoryIcon: UIImageView!
    @IBOutlet weak var secondCategoryLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
