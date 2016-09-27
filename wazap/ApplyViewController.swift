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
    var firstCategoryNow : [String] = []
    var firstCategoryEnd : [String] = []
    var secondCategoryNow : [String] = []
    var secondCategoryEnd : [String] = []
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController!.title = "신청목록"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        reloadData()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 87/255, blue: 255/255, alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Noto Sans KR", size: 20)!]
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
        let cell = self.tableView.cellForRowAtIndexPath(myIndexPath!) as! ApplyTableViewCell
        var contest:JSON = JSON.null
        var category = ""
        
        
        switch myIndexPath!.section{
        case 0:
            detailViewController.contests_id = self.applyListNow[row]["contests_id"].intValue
            contest = self.applyListNow[row]
            category += self.firstCategoryNow[row]
            if self.secondCategoryNow[row] != "없음" {
                category += ("\n" + self.firstCategoryNow[row])
            }
        case 1:
            detailViewController.contests_id = self.applyListEnd[row]["contests_id"].intValue
            contest = self.applyListEnd[row]
            category += self.firstCategoryEnd[row]
            if self.secondCategoryEnd[row] != "없음" {
                category += ("\n" + self.firstCategoryEnd[row])
            }
        default:
            break
        }
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        
        let content_writer = contest["cont_writer"].intValue
        
        print(contest)
        
        
        
        
        //D - Day 변환 로직
        if let dayString:String = contest["period"].stringValue{
            //String을 NSDate로 변환
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            if let formattedDate = formatter.dateFromString(dayString){
                //앞의 자리수로 자르고 day라벨에 집어넣기
                formatter.dateFormat = "yyyy-MM-dd"
                
                //D-day 표시
                let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                if (toDate > 0){
                    detailViewController.dueDay = "D - " + String(Int(toDate))
                }
                else{
                    detailViewController.dueDay = "마감"
                }
                
            }
        }
        
        detailViewController.contests_id = contest["contests_id"].intValue
        detailViewController.contests = contest
        detailViewController.category = category
        
        //카테고리 변환 로직
        let stringcontest:JSON = contest["categories"]
        if let wordsInclude = stringcontest.string?.characters.dropFirst().dropLast().split(",").map(String.init){
            for words in wordsInclude{
                detailViewController.categoryArr.append(String(words.characters.dropFirst().dropLast()))
            }
        }
        
        
        let button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRect(x: 0, y: detailViewController.view.frame.size.height / 12 * 11, width: detailViewController.view.frame.size.width, height: detailViewController.view.frame.size.height / 12)
        button.backgroundColor = UIColor(colorLiteralRed: 127/255, green: 127/255, blue: 127/255, alpha: 0.5)
        //!! 글쓴이가 아니면 신청하기,스크랩 버튼 추가, 글쓴이이면 마감버튼 추가
        if (content_writer != Int(FBSDKAccessToken.currentAccessToken().userID)){
            //신청하기 버튼 추가
            button.setTitle("신청하기", forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
            button.addTarget(detailViewController, action: #selector(detailViewController.applyTouch(_:)), forControlEvents: .TouchUpInside)
            button.tag = 1004
            detailViewController.view.addSubview(button)
            
            print("신청하기 버튼 추가")
            
            //스크랩버튼 추가
            let scrapButton: UIButton = UIButton()
            var ui_image:UIImage;
            if (contest["is_clip"].boolValue == false)
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
        }
        else{
            button.setTitle("마감하기", forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
            button.addTarget(detailViewController, action: #selector(detailViewController.closeTouch(_:)), forControlEvents: .TouchUpInside)
            detailViewController.view.addSubview(button)
            
            let moreButton = UIBarButtonItem(title: "···", style: .Plain, target: detailViewController, action: #selector(detailViewController.moreTouch(_:)))
            detailViewController.navigationItem.setRightBarButtonItem(moreButton, animated: true)
        }
        
        //프로필 사진 적용
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/\(contest["contests_id"].intValue)",parameters:[:] ,headers: header).responseJSON{
            response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let contests = json["data"]
                    let profileString = contests["profile_img"].stringValue
                    let profileURL = NSURL(string: profileString.stringByRemovingPercentEncoding!)!
                    
                    detailViewController.kakaoLabel.text = contests["kakao_id"].stringValue
                    detailViewController.profileImageView.kf_setImageWithURL(profileURL, completionHandler:{
                        (image, error, cacheType, imageURL) -> () in
                        detailViewController.profileImageView.image = detailViewController.profileImageView.image?.af_imageRoundedIntoCircle()
                        //detailViewController.profileImage = image! as UIImage
                    })
                }
            case .Failure(let error):
                print(error)
                detailViewController.profileImageView.image = UIImage(named: "default-user2")!.af_imageRoundedIntoCircle()
            }
        }
        
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
        
        switch(indexPath.section){
        case 0:
            //cell.dueDay.text = self.applyList![row]["title"]
            let row = indexPath.row
            cell.titleLabel.text = String(self.applyListNow[row]["title"])
            cell.recruitLabel.text = String(self.applyListNow[row]["recruitment"])
            cell.applierLabel.text = String(self.applyListNow[row]["appliers"])
            cell.confirmLabel.text = String(self.applyListNow[row]["members"])
            cell.endImage.hidden = true
            cell.dueDayLabel.hidden = false
            
            if let dayString:String = self.applyListNow[row]["period"].stringValue {
                //String을 NSDate로 변환
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                if let formattedDate = formatter.dateFromString(dayString){
                    //앞의 자리수로 자르고 day라벨에 집어넣기
                    formatter.dateFormat = "yyyy-MM-dd"
                    //D-day 표시
                    let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                    cell.dueDayLabel.text = "D-" + String(Int(toDate))
                }
            }
            
            
            cell.cancleButton.tag = row as Int
        case 1:
            let row = indexPath.row
            cell.titleLabel.text = String(self.applyListEnd[row]["title"])
            cell.recruitLabel.text = String(self.applyListEnd[row]["recruitment"])
            cell.applierLabel.text = String(self.applyListEnd[row]["appliers"])
            cell.confirmLabel.text = String(self.applyListEnd[row]["members"])
            cell.endImage.hidden = false
            cell.endImage.image = UIImage(named: "require_info_end_label")
            cell.dueDayLabel.hidden = true
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
                
                self.firstCategoryEnd.removeAll()
                self.secondCategoryEnd.removeAll()
                self.firstCategoryNow.removeAll()
                self.secondCategoryNow.removeAll()
                for (key : subJson):(String, JSON) in self.applyList!{
                    if(subJson.1["is_finish"].boolValue == true){ //끝난 목록
                        jsonArrayEnd.append(subJson.1)
                        //cell for row에 파싱해서 넣으면 버그때문에 여기서!
                        if let wordsInclude = subJson.1["categories"].string?.characters.dropFirst().dropLast().split(",").map(String.init){
                            for (index,words) in wordsInclude.enumerate(){
                                switch index{
                                case 0:
                                    self.firstCategoryEnd.append(String(words.characters.dropFirst().dropLast()))
                                case 1:
                                    self.secondCategoryEnd.append(String(words.characters.dropFirst().dropLast()))
                                default:
                                    break
                                }
                                if(wordsInclude.count == 1){
                                    self.secondCategoryEnd.append("없음")
                                }
                            }
                        }
                        
                    }
                    else{
                        jsonArrayNow.append(subJson.1)
                        //cell for row에 파싱해서 넣으면 버그때문에 여기서!
                        if let wordsInclude = subJson.1["categories"].string?.characters.dropFirst().dropLast().split(",").map(String.init){
                            for (index,words) in wordsInclude.enumerate(){
                                switch index{
                                case 0:
                                    self.firstCategoryNow.append(String(words.characters.dropFirst().dropLast()))
                                case 1:
                                    self.secondCategoryNow.append(String(words.characters.dropFirst().dropLast()))
                                default:
                                    break
                                }
                                if(wordsInclude.count == 1){
                                    self.secondCategoryNow.append("없음")
                                }
                            }
                        }
                    }
                }
                
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
