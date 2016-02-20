//
//  ArticleDetailViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 19..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var articleTitleLabel: UILabel! //모집명
    @IBOutlet weak var dueDayLabel: UILabel! // D-day
    @IBOutlet weak var organizerLabel: UILabel! //명칭 및 주관
    @IBOutlet weak var categoryLabel: UILabel! //카테고리
    @IBOutlet weak var recruitNumberLabel: UILabel! //모집인원
    @IBOutlet weak var nameListLabel: UILabel! //팀원 리스트
    @IBOutlet weak var nowNumberLabel: UILabel! //현재 신청중인 인원
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var introLabel: UITextView! //소개말
    
    var articleTitleLabelText : String?
    var dueDayLabelText : String?
    var organizerLabelText : String?
    var categoryLabelText : String?
    var recruitNumberLabelText : String?
    var nameListLabelText : String?
    var nowNumberLabelText : String?
    var hostNameLabelText : String?
    var introLabelText : String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(articleTitleLabelText!)
        
        articleTitleLabel.text = articleTitleLabelText!
        dueDayLabel.text = dueDayLabelText!
        organizerLabel.text = organizerLabelText!
        categoryLabel.text = categoryLabelText!
        recruitNumberLabel.text = recruitNumberLabelText!
        nameListLabel.text = nameListLabelText!
        nowNumberLabel.text = nowNumberLabelText!
        hostNameLabel.text = hostNameLabelText!
        introLabel.text = introLabelText!

        

        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func moreTouch(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "팀원모집", message: nil, preferredStyle: .ActionSheet)
        let modifyAction = UIAlertAction(title: "수정하기", style: UIAlertActionStyle.Default){
            UIAlertAction in print("modify")
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: UIAlertActionStyle.Destructive){
            UIAlertAction in print("OK Pressed")
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.Cancel){
            UIAlertAction in print("cancel")
        }
        alertController.addAction(modifyAction)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
