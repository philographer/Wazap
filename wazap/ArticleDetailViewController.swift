//
//  ArticleDetailViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 19..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit

class ArticleDetailViewController: UIViewController {
    
    /**
     @ Outlet
    */
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var hostsLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var recruitmentLabel: UILabel!
    @IBOutlet weak var teamListLabel: UILabel!
    @IBOutlet weak var appliersLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var coverLabel: UITextView!
    
    /** Variables
     
    @ contests_id : 25,
    @ title : "넥스터즈 공모전",
    @ recruitment : 5,
    @ cont_writer : "홍길동",
    @ hosts : "네이버",
    @ categories : "개발/디지인",
    @ period : "2016/07/24",
    @ cover : "200자 소개글입니다.",
    @ positions : "개발자/디자인/기획자",
    @ members : 3,
    @ appliers : 20,
    @ clips : 30,
    @ views : 50
     
    */
    
    var contests_id: Int?
    
    /**
     @ 뷰 로드
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //상세정보 받아옴
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/\(self.contests_id!)", parameters: nil).responseJSON{
            response in
            if let JSON = response.result.value{
                // 받아온 상세정보 라벨에 집어넣음
                self.titleLabel.text = JSON["data"]!!["title"] as? String
                self.hostsLabel.text = JSON["data"]!!["hosts"] as? String
                self.categoryLabel.text = String(JSON["data"]!!["category"])
                self.recruitmentLabel.text = String(JSON["data"]!!["recruitment"] as! Int)
                self.writerLabel.text = String(JSON["data"]!!["cont_writer"] as! Int)
                self.coverLabel.text = JSON["data"]!!["cover"] as? String
                
                //D-day 변환 로직
                if let dayString:String = JSON["data"]!!["period"] as? String{
                    //String을 NSDate로 변환
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                    if let formattedDate = formatter.dateFromString(dayString){
                        //앞의 자리수로 자르고 day라벨에 집어넣기
                        formatter.dateFormat = "yyyy-MM-dd"
                        
                        //D-day 표시
                        let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                        if (toDate > 0){
                            self.dueDayLabel.text = "D-" + String(Int(toDate))
                        }
                        else{
                            self.dueDayLabel.text = "마감"
                        }
                        
                    }
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /**
     @ 더보기 버튼 Function
     */
    @IBAction func moreTouch(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "팀원모집", message: nil, preferredStyle: .ActionSheet)
        
        let deleteOkAction = UIAlertAction(title: "삭제", style: .Default){
            UIAlertAction in
            let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString
            print(access_token)
            Alamofire.request(.DELETE, "http://come.n.get.us.to/contest/\(self.contests_id!)", parameters: ["access_token": access_token]).responseJSON{
                response in
                print(response)
                if let JSON = response.result.value{
                    print(JSON["msg"])
                }
            }
        }
        
        let deleteCancelAction = UIAlertAction(title: "취소", style: .Destructive){
            UIAlertAction in
            print("Cancel")
        }
        
        let modifyAction = UIAlertAction(title: "수정하기", style: UIAlertActionStyle.Default){
            UIAlertAction in
            print("modify")
        }
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: UIAlertActionStyle.Destructive){
            UIAlertAction in
            print("Delete")
            let deleteController = UIAlertController(title: "삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .Alert)
            deleteController.addAction(deleteOkAction)
            deleteController.addAction(deleteCancelAction)
            self.presentViewController(deleteController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.Cancel){
            UIAlertAction in
            print("cancel")
        }
        
        alertController.addAction(modifyAction)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
