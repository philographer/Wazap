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
import SwiftyJSON

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
    @IBOutlet weak var moreButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var kakaoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    var contests: AnyObject?
    var categoryArr: [String] = []
    var applies_id: String?
    
    /**
     @ 뷰 로드
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(contests_id)
        print("contests_id: \(contests_id!)")
        //print("applies_id: \(applies_id!) ")
    }

    
    override func viewWillLayoutSubviews() {
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        

        //상세정보 받아옴
        var content_writer: Int?
        var isApllier = false
        let access_token = FBSDKAccessToken.currentAccessToken().tokenString as String
        
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/\(self.contests_id!)", parameters: ["access_token":access_token]).responseJSON{
            response in
            if let responseVal = response.result.value{
                //받아온 정보 contests에 할당
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                
                self.contests = responseVal["data"]!!
                let stringJSON:JSON = JSON(responseVal["data"]!!["categories"]!!)
                if let wordsInclude = stringJSON.string?.characters.dropFirst().dropLast().split(",").map(String.init){
                    for words in wordsInclude{
                        self.categoryArr.append(String(words.characters.dropFirst().dropLast()))
                    }
                }
                
                // 받아온 상세정보 라벨에 집어넣음
                self.titleLabel.text = responseVal["data"]!!["title"] as? String
                self.hostsLabel.text = responseVal["data"]!!["hosts"] as? String
                self.categoryLabel.text = String(self.categoryArr)
                self.recruitmentLabel.text = String(responseVal["data"]!!["recruitment"] as! Int)
                self.writerLabel.text = String(responseVal["data"]!!["cont_writer"] as! Int)
                self.coverLabel.text = responseVal["data"]!!["cover"] as? String
                self.appliersLabel.text = responseVal["data"]!!["appliers"]!?.stringValue
                self.kakaoLabel.text = responseVal["data"]!!["kakao_id"] as? String
                
                
                //content_writer 값 할당
                content_writer = responseVal["data"]!!["cont_writer"]!! as? Int
                
                
                
                //!! 신청자인지 검사 !!
                request(.GET, "http://come.n.get.us.to/contests/applications", parameters: ["access_token": access_token]).responseJSON{
                    response in
                    if let responseValue = response.result.value{
                        let json = JSON(responseValue)
                        let jsonData = json["data"]
                        for var i = 0; i < jsonData.count; i++ {
                            //신청자이면
                            if(jsonData[i]["contests_id"].intValue == self.contests_id!){
                                isApllier = true
                                self.applies_id = jsonData[i]["applies_id"].stringValue
                            }
                        }
                        /*
                        if(isApllier){
                            print("신청자입니다")
                        }else{
                            print("신청자가 아닙니다")
                        }
                        */
                        
                        //!! 글쓴이가 아니고 신청릉 안 했으면 More버튼을 숨기고 마감하기 버튼도 숨기고 신청하기버튼 추가
                        if ((content_writer! != Int(FBSDKAccessToken.currentAccessToken().userID)) && (!isApllier)){
                            //신청하기 버튼 추가
                            print("신청버튼 추가할래요")
                            let button = UIButton(type: UIButtonType.System) as UIButton
                            button.frame = CGRect(x: 0, y: self.view.frame.size.height / 12 * 11, width: self.view.frame.size.width, height: self.view.frame.size.height / 12)
                            button.backgroundColor = UIColor(colorLiteralRed: 127/255, green: 127/255, blue: 127/255, alpha: 0.5)
                            button.setTitle("신청하기", forState: .Normal)
                            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                            button.titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
                            button.addTarget(self, action: "applyTouch:", forControlEvents: .TouchUpInside)
                            self.view.addSubview(button)
                            
                            //더보기, 마감하기 버튼 없애기
                            self.moreButton.title = ""
                            self.moreButton.enabled = false
                            self.closeButton.hidden = true
                        }//!! 글쓴이가 아니고 신청을 했으면 More버튼을 숨기고 마감하기 버튼도 숨기고 신청 취소버튼을 추가 !!
                        else if((content_writer! != Int(FBSDKAccessToken.currentAccessToken().userID)) && (isApllier))
                        {
                            print("신청취소버튼 추가할래요")
                            print("현재 글번호는 \(self.contests_id)")
                            print("제 아이디는 \(FBSDKAccessToken.currentAccessToken().userID)")
                            //신청 취소버튼 추가
                            let button = UIButton(type: UIButtonType.System) as UIButton
                            button.frame = CGRect(x: 0, y: self.view.frame.size.height / 12 * 11, width: self.view.frame.size.width, height: self.view.frame.size.height / 12)
                            button.backgroundColor = UIColor(colorLiteralRed: 127/255, green: 127/255, blue: 127/255, alpha: 0.5)
                            button.setTitle("신청 취소", forState: .Normal)
                            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                            button.titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
                            button.addTarget(self, action: "cancelTouch:", forControlEvents: .TouchUpInside)
                            self.view.addSubview(button)
                            
   
                            //더보기, 마감하기 버튼 없애기
                            self.moreButton.title = ""
                            self.moreButton.enabled = false
                            self.closeButton.hidden = true
                            
                            //신청하기 버튼 없애기
                            for subview in self.view.subviews
                            {
                                if subview.tag == 1004{
                                    subview.removeFromSuperview()
                                }
                            }
                            
                        }
                    }
                }
                
                //D-day 변환 로직
                if let dayString:String = responseVal["data"]!!["period"] as? String{
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
    
    func applyTouch(sender: UIButton!)
    {
        let access_token = FBSDKAccessToken.currentAccessToken().tokenString as String
        Alamofire.request(.POST, "http://come.n.get.us.to/contests/\(contests_id!)/join", parameters: ["access_token": access_token]).responseJSON{
            response in
            if let JSON = response.result.value{
                let alertController = UIAlertController(title: "신청결과", message: JSON["msg"]!! as? String, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "ok", style: .Default, handler: {(action) in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    /**
     @ 신청 취소 버튼 Function
    */
    func cancelTouch(sender: UIButton!){
        let access_token = FBSDKAccessToken.currentAccessToken().tokenString as String
        //print(FBSDKAccessToken.currentAccessToken().userID)
        print(access_token)
        // /contests/:contest_id/:applies_id
        Alamofire.request(.DELETE, "http://come.n.get.us.to/contests/\(contests_id!)/join", parameters: ["access_token": access_token]).responseJSON{
            response in
            print(response)
            if let JSON = response.result.value{
                let alertController = UIAlertController(title: "신청 취소", message: JSON["msg"]!! as? String, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "ok", style: .Default, handler: {(action) in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }

    /**
     @ 더보기 버튼 Function
    */
    @IBAction func moreTouch(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "신청하기", message: nil, preferredStyle: .ActionSheet)
        
        let confirmAction = UIAlertAction(title: "확인", style: .Default, handler: { (action) in
            self.navigationController?.popViewControllerAnimated(true)
        })
        
        let deleteOkAction = UIAlertAction(title: "삭제", style: .Default){
            UIAlertAction in
            let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString as String
            Alamofire.request(.DELETE, "http://come.n.get.us.to/contests/\(self.contests_id!)", parameters: ["access_token": access_token]).responseJSON{
                response in
                if let JSON = response.result.value{
                    
                    let alertController = UIAlertController(title: "삭제하기", message: JSON["msg"]!! as? String, preferredStyle: .Alert)
                    alertController.addAction(confirmAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
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
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("writeViewController") as! WriteViewController
            self.presentViewController(viewController, animated: true, completion: nil)
            
            viewController.titleLabel.text = self.titleLabel.text
            viewController.introTextView.text = self.coverLabel.text
            viewController.recruitValue = self.contests!["recruitment"] as! Int
            viewController.organizerLabel.text = self.contests!["hosts"] as? String
            viewController.periodDate = self.contests!["period"] as! String
            viewController.contest_id = self.contests_id
            viewController.isModify = true
            
            //카테고리 색깔 바꿔줌
            for category in self.categoryArr {
                switch category{
                case "디자인/UCC":
                    viewController.category_design_ucc = true
                    viewController.designUccButton.tintColor = UIColor.redColor()
                case "IT/개발":
                    viewController.category_it_dev = true
                    viewController.itDevButton.tintColor = UIColor.redColor()
                case "마케팅/광고":
                    viewController.category_market_ad = true
                    viewController.marketAdButton.tintColor = UIColor.redColor()
                case "논문/문학":
                    viewController.category_paper_literature = true
                    viewController.paperLiteratureButton.tintColor = UIColor.redColor()
                case "게임":
                    viewController.category_game = true
                    viewController.gameButton.tintColor = UIColor.redColor()
                case "ETC":
                    viewController.category_etc = true
                    viewController.etcButton.tintColor = UIColor.redColor()
                default:
                    break
                }
            }
            
            //날짜 바꿔줌
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            viewController.dayPicker.setDate(formatter.dateFromString(viewController.periodDate)!, animated: true)
            
            //모집인원 바꿔줌
            viewController.recruitNumberPicker.selectRow(viewController.recruitValue-2, inComponent: 0, animated: true)
            
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
    
    /**
     @ 마감하기 버튼
    */
    @IBAction func closeTouch(sender: AnyObject) {
        
        
        print("마감하기")
        print("현재 글번호는 \(self.contests_id!)")
        print("제 아이디는 \(FBSDKAccessToken.currentAccessToken().userID)")
        print("\(FBSDKAccessToken.currentAccessToken().tokenString)")
        let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString as String
        
        Alamofire.request(.PUT, "http://come.n.get.us.to/contests/finish/\(self.contests_id!)", parameters: ["access_token": access_token], encoding: .JSON).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                print(json["msg"])
                let alertController = UIAlertController(title: "마감", message: json["msg"].stringValue, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(action) in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
        /*
        print("마감하기버튼 크릭")
        print("현재 글번호는 \(self.contests_id)")
        print("제 아이디는 \(FBSDKAccessToken.currentAccessToken().userID)")
        print("\(FBSDKAccessToken.currentAccessToken().tokenString)")
        
        let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString as String
        print(access_token)
        Alamofire.request(.PUT, "http://come.n.get.us.to/contests/finish/\(self.contests_id)", parameters: ["access_token": access_token], encoding: .JSON).responseJSON{
                response in
                if let responseVal = response.result.value{
                    let json = JSON(responseVal)
                    let msg = json["msg"]
                    let data = json["data"]
                    
                    print(msg)
            }
        }
        */
    }
    
    @IBAction func detailProfile(sender: AnyObject) {
        let profileController = self.storyboard?.instantiateViewControllerWithIdentifier("profileViewController") as! MyProfileViewController
        
        profileController.facebookId = String(self.contests!["cont_writer"]!!)

        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    
    

}
