//
//  applyViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class ApplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /**
     @ Outlet
    */
    @IBOutlet weak var tableView: UITableView!
    
    /**
     @ Variables
    */
    
    var applyList : JSON?
    var applyListNow : JSON = JSON.null
    var applyListEnd : JSON = JSON.null
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destinationViewController as! ArticleDetailViewController
        let myIndexPath = self.tableView.indexPathForSelectedRow
        let row:Int = myIndexPath!.row
        detailViewController.contests_id = self.applyList![row]["contests_id"].intValue
        
        //var content_writer:Int?
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/\(detailViewController.contests_id!)", headers: header).responseJSON{
            response in
            if let responseVal = response.result.value{
                //print(responseVal["data"])
                //받아온 정보 contests에 할당
                let json = JSON(responseVal)
                
                detailViewController.contests = json["data"]
                let stringJSON:JSON = json["data"]["categories"]
                if let wordsInclude = stringJSON.string?.characters.dropFirst().dropLast().split(",").map(String.init){
                    for words in wordsInclude{
                        detailViewController.categoryArr.append(String(words.characters.dropFirst().dropLast()))
                    }
                }
                
                // 받아온 상세정보 라벨에 집어넣음
                let profileString = json["data"]["profile_img"].stringValue
                let profileURL = NSURL(string: profileString.stringByRemovingPercentEncoding!)!
                detailViewController.profileImage.kf_setImageWithURL(profileURL, completionHandler:{ (image, error, cacheType, imageURL) -> () in
                    if let profileImage = image{
                        detailViewController.profileImage.image = profileImage.af_imageRoundedIntoCircle()
                    }
                })
                detailViewController.titleLabel.text = json["data"]["title"].stringValue
                detailViewController.hostsLabel.text = json["data"]["hosts"].stringValue
                detailViewController.categoryLabel.text = String(detailViewController.categoryArr)
                detailViewController.recruitmentLabel.text = json["data"]["recruitment"].stringValue
                detailViewController.writerLabel.text = json["data"]["cont_writer"].stringValue
                detailViewController.coverLabel.text = json["data"]["cover"].stringValue
                detailViewController.appliersLabel.text = json["data"]["appliers"].stringValue
                detailViewController.kakaoLabel.text = json["data"]["kakao_id"].stringValue
                
                //content_writer 값 할당
                //content_writer = json["data"]["cont_writer"].intValue
                
                
                //!! 신청자인지 검사 !!
                var isApllier = false
                request(.GET, "http://come.n.get.us.to/contests/applications", headers: self.header).responseJSON{
                    response in
                    if let responseValue = response.result.value{
                        let json = JSON(responseValue)
                        let jsonData = json["data"]
                        for i in 0 ..< jsonData.count {
                            //신청자이면
                            if(jsonData[i]["contests_id"].intValue == detailViewController.contests_id!){
                                isApllier = true
                                detailViewController.applies_id = jsonData[i]["applies_id"].stringValue
                            }
                        }
                        /*
                         if(isApllier){
                         print("신청자입니다")
                         }else{
                         print("신청자가 아닙니다")
                         }
                         */
                        
                        //스크랩 버튼 추가
                        let scrapButton: UIButton = UIButton()
                        var ui_image:UIImage;
                        if (detailViewController.contests["is_clip"] == 0)
                        {
                            ui_image = UIImage(named: "heart1")!
                        }
                        else{
                            ui_image = UIImage(named: "heart2")!
                        }
                        scrapButton.setImage(ui_image, forState: .Normal)
                        scrapButton.frame = CGRectMake(0, 0, 25, 25)
                        scrapButton.addTarget(detailViewController, action: #selector(ArticleDetailViewController.scrapAction(_:)), forControlEvents: .TouchUpInside)
                        detailViewController.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: scrapButton), animated: true)
                        
                        //!! 글쓴이가 아니고 신청릉 안 했으면 More버튼을 숨기고 마감하기 버튼도 숨기고 신청하기버튼 추가
                        if (!isApllier){
                            //신청하기 버튼 추가
                            print("신청버튼 추가할래요")
                            dispatch_async(dispatch_get_main_queue(), {
                                let button = UIButton(type: UIButtonType.System) as UIButton
                                button.frame = CGRect(x: 0, y: self.view.frame.size.height / 12 * 11, width: self.view.frame.size.width, height: self.view.frame.size.height / 12)
                                button.backgroundColor = UIColor(colorLiteralRed: 127/255, green: 127/255, blue: 127/255, alpha: 0.5)
                                button.setTitle("신청하기", forState: .Normal)
                                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                                button.titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
                                button.addTarget(detailViewController, action: #selector(ArticleDetailViewController.applyTouch(_:)), forControlEvents: .TouchUpInside)
                                detailViewController.view.addSubview(button)
                            })//!! 글쓴이가 아니고 신청을 했으면 More버튼을 숨기고 마감하기 버튼도 숨기고 신청 취소버튼을 추가 !!
                            }
                            
                        else if(isApllier)
                        {
                            print("신청취소버튼 추가할래요")
                            print("제 아이디는 \(FBSDKAccessToken.currentAccessToken().userID)")
                            //신청 취소버튼 추가
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                let button = UIButton(type: UIButtonType.System) as UIButton
                                button.frame = CGRect(x: 0, y: self.view.frame.size.height / 12 * 11, width: self.view.frame.size.width, height: self.view.frame.size.height / 12)
                                button.backgroundColor = UIColor(colorLiteralRed: 127/255, green: 127/255, blue: 127/255, alpha: 0.5)
                                button.setTitle("신청 취소", forState: .Normal)
                                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                                button.titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
                                button.addTarget(detailViewController, action: #selector(ArticleDetailViewController.cancelTouch(_:)), forControlEvents: .TouchUpInside)
                                detailViewController.view.addSubview(button)
                                
                                //신청하기 버튼 없애기
                                for subview in detailViewController.view.subviews
                                {
                                    if subview.tag == 1004{
                                        subview.removeFromSuperview()
                                    }
                                }
                            })
                        }
                    }
                }
                //D-day 변환 로직
                if let dayString:String = json["data"]["period"].stringValue{
                    //String을 NSDate로 변환
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                    if let formattedDate = formatter.dateFromString(dayString){
                        //앞의 자리수로 자르고 day라벨에 집어넣기
                        formatter.dateFormat = "yyyy-MM-dd"
                        
                        //D-day 표시
                        let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                        if (toDate > 0){
                            detailViewController.dueDayLabel.text = "D-" + String(Int(toDate))
                        }
                        else{
                            detailViewController.dueDayLabel.text = "마감"
                        }
                        
                    }
                }
            }
        }
        /*
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/\(self.contests_id)/applies", parameters: ["access_token": access_token]).responseJSON{
        response in
        if let responseValue = response.result.value{
        print(responseValue["msg"])
        }
        }
        */
        
        
    }
    
    @IBAction func backButtonTouch(sender: AnyObject) {
        fadeOut()
        self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
    }
    
    /**
     @ Table
    */
     
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var row = 0
        
        switch(section){
        case 0:
            row = self.applyListNow.count
        case 1:
            row = self.applyListEnd.count
        default:0
        }
        
        return row
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("applyHeaderCell") as! ApplyTableViewHeaderCell
        headerCell.backgroundColor = UIColorFromRGB(0xf2f3f3)
        
        switch(section){
        case 0:
            headerCell.headerLabel.text = "지금까지 신청한 포스터를 확인하세요"
        case 1:
            headerCell.headerLabel.text = "마감된 포스터"
        default:
            break
        }
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerCellHeight:CGFloat
        
        switch(section){
        case 0:
            if(self.applyListNow.count == 0){
               headerCellHeight = 0
            }
            else{
               headerCellHeight = 70.0
            }
        case 1:
            if(self.applyListEnd.count == 0){
                headerCellHeight = 0
            }
            else{
                headerCellHeight = 70.0
            }
        default:
            headerCellHeight = 100.0
        }
        
        return headerCellHeight
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("applyCell") as! ApplyTableViewCell
        
        //헤더없이 하고싶다면?
        
        switch(indexPath.section){
        case 0:
            //cell.dueDay.text = self.applyList![row]["title"]
            let row = indexPath.row
            cell.titleLabel.text = String(self.applyListNow[row]["title"])
            cell.recruitLabel.text = String(self.applyListNow[row]["recruitment"])
            cell.applierLabel.text = String(self.applyListNow[row]["appliers"])
            cell.confirmLabel.text = String(self.applyListNow[row]["members"])
            
            if let dayString:String = self.applyList![row]["period"].stringValue {
                //String을 NSDate로 변환
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                if let formattedDate = formatter.dateFromString(dayString){
                    //앞의 자리수로 자르고 day라벨에 집어넣기
                    formatter.dateFormat = "yyyy-MM-dd"
                    cell.dueDayLabel.text = formatter.stringFromDate(formattedDate)
                    
                    //D-day 표시
                    let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                    if (toDate > 0){
                        cell.dueDayLabel.text = "D-" + String(Int(toDate))
                    }
                    else{
                        cell.dueDayLabel.text = "마감"
                    }
                }
            }
            cell.cancleButton.tag = row as Int
        case 1:
            let row = indexPath.row
            cell.titleLabel.text = String(self.applyListEnd[row]["title"])
            cell.recruitLabel.text = String(self.applyListEnd[row]["recruitment"])
            cell.applierLabel.text = String(self.applyListEnd[row]["appliers"])
            cell.confirmLabel.text = String(self.applyListEnd[row]["members"])
            
            if let dayString:String = self.applyList![row]["period"].stringValue {
                //String을 NSDate로 변환
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                if let formattedDate = formatter.dateFromString(dayString){
                    //앞의 자리수로 자르고 day라벨에 집어넣기
                    formatter.dateFormat = "yyyy-MM-dd"
                    cell.dueDayLabel.text = formatter.stringFromDate(formattedDate)
                    
                    //D-day 표시
                    let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                    if (toDate > 0){
                        cell.dueDayLabel.text = "D-" + String(Int(toDate))
                    }
                    else{
                        cell.dueDayLabel.text = "마감"
                    }
                }
            }
            cell.cancleButton.tag = row as Int
        default:
            break
        }

        return cell
    }
    
    
    /**
     @ FadeIn FadeOut Function
     */
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.view.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.alpha = 0.0
            }, completion: nil)
    }
    
    //상세보기 모달
    func detailModal(sender:UIButton){
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! ArticleDetailViewController
        let row = sender.tag
        let contests_id = self.applyList![row]["contests_id"].intValue
        let applies_id = self.applyList![row]["applies_id"].stringValue
        
        print("contest_id: \(contests_id)")
        print("applies_id: \(applies_id)")
        
        detailViewController.contests_id = contests_id
        detailViewController.applies_id = applies_id
        
        //self.applyList![row]["contests_id"].intValue 여기서 받자
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    func reloadData(){
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/applications",headers: header ,parameters: ["amount": 30]).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                print(json)
                self.applyList = json["data"]
                var jsonArrayNow:[JSON] = []
                var jsonArrayEnd:[JSON] = []
                for (key : subJson):(String, JSON) in self.applyList!{
                    if(subJson.1["is_finish"].boolValue == true){
                        jsonArrayEnd.append(subJson.1)
                    }
                    else{
                        jsonArrayNow.append(subJson.1)
                    }
                }
                
                self.applyListNow = JSON(jsonArrayNow)
                self.applyListEnd = JSON(jsonArrayEnd)
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func cancleAction(sender: AnyObject) {
        let row = sender.tag
        let contests_id = self.applyList![row]["contests_id"].intValue
        Alamofire.request(.DELETE, "http://come.n.get.us.to/contests/\(contests_id)/join", headers: header).responseJSON{
            response in
            print(response)
            if let JSON = response.result.value{
                let alertController = UIAlertController(title: "신청 취소", message: JSON["msg"]!! as? String, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "ok", style: .Default, handler: {(action) in
                    self.navigationController?.popViewControllerAnimated(true)
                    self.reloadData()
                })
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
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
