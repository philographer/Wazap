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
    @IBOutlet weak var dueTime: UILabel! //남은 시간
    @IBOutlet weak var category: UILabel! //카테고리
    @IBOutlet weak var tagList: UILabel! //태그 리스트
    @IBOutlet weak var hostName: UILabel! //주최자
    @IBOutlet weak var scrapButton: UIButton! //스크랩버튼

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
