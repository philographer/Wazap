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
    @IBOutlet weak var kakaoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView3: UIView!
    @IBOutlet weak var coverConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerViewBottomConstraint: NSLayoutConstraint!
    
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
    var contests: JSON = JSON.null
    var detailContests: JSON = JSON.null
    var categoryArr: [String] = []
    var applies_id: String?
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    var dueDay: String?
    var category: String?
    
    //이전 뷰에서 PrepareForSegue에서 받아오겠지만, 혹시 못 받아왔을 경우에 image set
    var profileImage : UIImage?{
        didSet {
            if self.profileImageView.image == nil{
                self.profileImageView.image = profileImage?.af_imageRoundedIntoCircle()
                print("nil")
            }
        }
    }
    
    
    
    
    /**
     @ 뷰 로드
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //스크롤뷰 오토레이아웃 버그때문에 추가함(프로필 상세보기를 열면 스크롤뷰가 내려감)
        self.automaticallyAdjustsScrollViewInsets = false
        
        //값 셋팅
        self.titleLabel.text = self.contests["title"].stringValue
        self.contTitleLabel.text = self.contests["cont_title"].stringValue
        self.recruitmentLabel.text =
            self.contests["members"].stringValue + " / " + self.contests["recruitment"].stringValue
        self.writerLabel.text = self.contests["username"].stringValue
        self.hostsLabel.text = self.contests["hosts"].stringValue
        //self.categoryLabel.text = String(self.categoryArr)
        self.coverLabel.text = self.contests["cover"].stringValue
        self.appliersLabel.text = self.contests["appliers"].stringValue
        self.locationLabel.text = self.contests["cont_locate"].stringValue
        self.positionLabel.text = self.contests["positions"].stringValue
        self.dueDayLabel.text = self.dueDay
        self.dueDayLabel.layer.borderColor = UIColorFromRGB(0xFF0000).CGColor
        self.dueDayLabel.layer.borderWidth = 0.5
        self.dueDayLabel.layer.cornerRadius = 10
        self.dueDayLabel.layer.masksToBounds = true
        
        self.categoryLabel.text = self.category
    }
    
    override func viewDidLayoutSubviews() {
        //스크롤뷰 최소 높이 지정
        
        let screenHeight = UIScreen.mainScreen().bounds.height
        let statusBarHeight:CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let navigtionBarHeight:CGFloat = 44
        //네비게이션바 사이즈(self.navigationController?.navigationBar.frame.height)!
        innerViewConstraint.constant = screenHeight - innerView3.frame.origin.y - statusBarHeight - navigtionBarHeight - self.view.frame.size.height / 12 - 5
        innerViewBottomConstraint.constant = self.view.frame.size.height / 12
        
        print(innerViewConstraint.constant)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //타이틀을 이미지로 변경
        var titleView : UIImageView
        // set the dimensions you want here
        titleView = UIImageView(frame:CGRectMake(0, 0, 50, 45))
        // Set how do you want to maintain the aspect
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "detail_title_banner-4")
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        /*dispatch_async(dispatch_get_main_queue(), {
            var titleView : UIImageView
            // set the dimensions you want here
            titleView = UIImageView(frame:CGRectMake(0, 0, 10, 25))
            // Set how do you want to maintain the aspect
            //titleView.contentMode = .ScaleAspectFit
            titleView.image = UIImage(named: "detail_title_banner-1")
            self.navigationItem.titleView = titleView
        })
        */
        
        self.activityIndicator.hidden = true
        self.activityIndicator.startAnimating()
        
        //scrollView setContentOffset:CGPointZero
        
        //self.scrollView.setContentOffset(CGPointZero, animated: false)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /**
     @ 스크랩 버튼
    */
    
    func scrapAction(sender: UIButton)
    {
        let is_clip:Bool = self.contests["is_clip"].boolValue
        if(is_clip){
            //찜 삭제
            Alamofire.request(.DELETE, "http://come.n.get.us.to/clips/\(self.contests["contests_id"].stringValue)", headers: header).responseJSON{
                response in
                if let JSON = response.result.value{
                    let alertController = UIAlertController(title: "찜삭제", message: JSON["msg"] as? String, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(action) in
                        self.contests["is_clip"].boolValue = !self.contests["is_clip"].boolValue
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    sender.setImage(UIImage(named: "heart1"), forState: .Normal)
                }
            }
        }
        else{
            //찜하기
            Alamofire.request(.POST, "http://come.n.get.us.to/clips/\(self.contests["contests_id"].stringValue)", headers: header).responseJSON{
                response in
                if let JSON = response.result.value{
                    let alertController = UIAlertController(title: "찜하기", message: JSON["msg"] as? String, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(action) in
                        self.contests["is_clip"].boolValue = !self.contests["is_clip"].boolValue
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    sender.setImage(UIImage(named: "heart2"), forState: .Normal)
                }
            }
        }
    }
    
    
    func applyTouch(sender: UIButton!)
    {
        Alamofire.request(.POST, "http://come.n.get.us.to/contests/\(contests_id!)/join", headers: header).responseJSON{
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
        //print(FBSDKAccessToken.currentAccessToken().userID)
        // /contests/:contest_id/:applies_id
        Alamofire.request(.DELETE, "http://come.n.get.us.to/contests/\(contests_id!)/join", headers: header).responseJSON{
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
            Alamofire.request(.DELETE, "http://come.n.get.us.to/contests/\(self.contests_id!)", headers: self.header).responseJSON{
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
            viewController.recruitValue = self.contests["recruitment"].intValue
            viewController.organizerLabel.text = self.contests["hosts"].stringValue
            viewController.periodDate = self.contests["period"].stringValue
            viewController.contest_id = self.contests_id
            viewController.isModify = true
            viewController.contentTitleLabel.text = self.contests["cont_title"].stringValue
            viewController.recruitLabel.text = self.contests["recruitment"].stringValue + "명"
            viewController.recruitPicker.selectRow(self.contests["recruitment"].intValue - 2, inComponent: 0, animated: true)
            viewController.locationLabel.text = self.contests["cont_locate"].stringValue
            
            viewController.positionLabel.text = self.contests["positions"].stringValue
            
            //날짜 바꿔줌
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            let detailDate = formatter.dateFromString(self.contests["period"].stringValue)!
            viewController.datePicker.setDate(detailDate, animated: true)
            formatter.dateFormat = "yyyy-MM-dd"
            viewController.dateTextLabel.text = formatter.stringFromDate(detailDate)
            
            
            print(self.categoryArr)
            
            if self.categoryArr.contains("광고/아이디어/마케팅"){
                viewController.adIdeaMarketingButton.isChecked = true
            }
            if self.categoryArr.contains("디자인"){
                viewController.designButton.isChecked = true
            }
            if self.categoryArr.contains("사진/UCC"){
                viewController.picUccButton.isChecked = true
            }
            if self.categoryArr.contains("해외"){
                viewController.foreignButton.isChecked = true
            }
            if self.categoryArr.contains("게임/소프트웨어"){
                viewController.gameSoftwareButton.isChecked = true
            }
            if self.categoryArr.contains("기타"){
                viewController.etcButton.isChecked = true
            }
            
            
            
            
            
            
            //viewController.dayPicker.setDate(formatter.dateFromString(viewController.periodDate)!, animated: true)
            
            //모집인원 바꿔줌
            //viewController.recruitNumberPicker.selectRow(viewController.recruitValue-2, inComponent: 0, animated: true)
            
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
        
        Alamofire.request(.PUT, "http://come.n.get.us.to/contests/finish/\(self.contests_id!)", headers: header, encoding: .JSON).responseJSON{
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
    
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func detailProfile(sender: AnyObject) {
        let profileController = self.storyboard?.instantiateViewControllerWithIdentifier("profileViewController") as! MyProfileViewController
        profileController.facebookId = String(self.contests["cont_writer"].stringValue)
        
        let closeBtn = UIBarButtonItem(title: "뒤로", style: .Plain, target: profileController, action: #selector(profileController.closeView))
        //profileController.navigationItem.setRightBarButtonItem(closeBtn, animated: true)
        profileController.profileNavigationBar?.leftBarButtonItem = closeBtn
        self.presentViewController(profileController, animated: true, completion: nil)
        
        
        
        //self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    
    

}
