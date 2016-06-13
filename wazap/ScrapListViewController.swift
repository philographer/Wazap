//
//  ScrapListViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import SwiftyJSON


class ScrapListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var scrapList:JSON? //스크랩 리스트
    var scrapListNow : JSON = JSON.null
    var scrapListEnd : JSON = JSON.null
    
    var firstCategoryNow : [String] = []
    var firstCategoryEnd : [String] = []
    var secondCategoryNow : [String] = []
    var secondCategoryEnd : [String] = []
    
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    
    
    /**
     @ Outlet
    */
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.loadData()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0/255, green: 87/255, blue: 255/255, alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Noto Sans KR", size: 20)!]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destinationViewController as! ArticleDetailViewController
        let myIndexPath = self.tableView.indexPathForSelectedRow
        let row:Int = myIndexPath!.row
        
        
        
        switch myIndexPath!.section{
            case 0:
                detailViewController.contests_id = self.scrapListNow[row]["contests_id"].intValue
            case 1:
                detailViewController.contests_id = self.scrapListEnd[row]["contests_id"].intValue
            default:
                break
        }
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        
        //var content_writer: Int?
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
                            let button = UIButton(type: UIButtonType.System) as UIButton
                            button.frame = CGRect(x: 0, y: self.view.frame.size.height / 12 * 11, width: self.view.frame.size.width, height: self.view.frame.size.height / 12)
                            button.backgroundColor = UIColor(colorLiteralRed: 127/255, green: 127/255, blue: 127/255, alpha: 0.5)
                            button.setTitle("신청하기", forState: .Normal)
                            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                            button.titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
                            button.addTarget(detailViewController, action: #selector(ArticleDetailViewController.applyTouch(_:)), forControlEvents: .TouchUpInside)
                            button.layer.zPosition = 100
                            detailViewController.view.addSubview(button)
                        }//!! 글쓴이가 아니고 신청을 했으면 More버튼을 숨기고 마감하기 버튼도 숨기고 신청 취소버튼을 추가 !!
                        else if(isApllier)
                        {
                            print("신청취소버튼 추가할래요")
                            print("제 아이디는 \(FBSDKAccessToken.currentAccessToken().userID)")
                            //신청 취소버튼 추가
                            let button = UIButton(type: UIButtonType.System) as UIButton
                            button.frame = CGRect(x: 0, y: self.view.frame.size.height / 12 * 11, width: self.view.frame.size.width, height: self.view.frame.size.height / 12)
                            button.backgroundColor = UIColor(colorLiteralRed: 127/255, green: 127/255, blue: 127/255, alpha: 0.5)
                            button.setTitle("신청 취소", forState: .Normal)
                            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                            button.titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
                            button.addTarget(detailViewController, action: #selector(ArticleDetailViewController.cancelTouch(_:)), forControlEvents: .TouchUpInside)
                            button.layer.zPosition = 100
                            detailViewController.view.addSubview(button)
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

    /**
     @ Table
    */

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerCellHeight:CGFloat
        
        switch(section){
        case 0:
            if(self.scrapListNow.count == 0){
                headerCellHeight = 0
            }
            else{
                headerCellHeight = 70.0
            }
        case 1:
            if(self.scrapListEnd.count == 0){
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
    
    
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("scrapHeaderCell") as! ScrapTableViewHeaderCell
        //headerCell.backgroundColor = UIColor(red: 0x72, green: 0x72, blue: 0x72, alpha: CGFloat(1.0))
        headerCell.backgroundColor = UIColorFromRGB(0xf2f3f3)
        
        switch(section){
        case 0:
            headerCell.headerLabel.text = "함께하고 싶은 팀에 신청하세요"
        case 1:
            headerCell.headerLabel.text = "마감된 공모"
        default:
            break
        }
        
        return headerCell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0
        
        switch(section){
        case 0:
            row = self.scrapListNow.count
        case 1:
            row = self.scrapListEnd.count
        default:
            break
        }
        
        return row
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("scrapCell", forIndexPath: indexPath) as! ScrapTableViewCell
        let row = indexPath.row
        switch(indexPath.section){
        case 0:
            cell.titleLabel.text = String(self.scrapListNow[row]["title"])
            cell.recruitLabel.text = String(self.scrapListNow[row]["recruitment"])
            if(self.scrapListNow[row]["is_apply"].intValue == 1){
                cell.applyButton.setImage(UIImage(named: "scrap_info_button_down"), forState: .Normal)
            }else{
                cell.applyButton.setImage(UIImage(named: "scrap_info_button"), forState: .Normal)
            }
            cell.titleLabel.textColor = UIColor.blackColor()
            cell.recruitLabel.textColor = UIColor.scrapCategory()
            cell.firstCategoryLabel.textColor = UIColor.scrapCategory()
            cell.recruitNumberLabel.textColor = UIColor.scrapCategory()
            
            //D-Day 변환 로직
            if let dayString:String = self.scrapListNow[row]["period"].stringValue {
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
                        cell.endImage.hidden = true
                    }
                    else{
                        cell.dueDayLabel.text = "마감"
                        print("마감이라 표시할꺼")
                    }
                }
            }
            
            //@ Todo: 중복코드 Refactoring 필요
            cell.firstCategoryLabel.text = firstCategoryNow[row]
            switch self.firstCategoryNow[row] {
            case "광고/아이디어/마케팅":
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_idea")
            case "디자인":
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_design")
            case "사진/UCC":
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_video")
            case "게임/소프트웨어":
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_it")
            case "해외":
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_marketing")
            case "기타":
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_scenario")
            default:
                print("default section 0 first")
            }
            if(secondCategoryNow[row] != "없음"){
                cell.secondCategoryLabel.text = secondCategoryNow[row]
            }
            switch self.secondCategoryNow[row] {
            case "광고/아이디어/마케팅":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_idea")
            case "디자인":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_design")
            case "사진/UCC":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_video")
            case "게임/소프트웨어":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_it")
            case "해외":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_marketing")
            case "기타":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_scenario")
            default:
                print("default section 0 second")
                cell.secondCategoryIcon.image = UIImage()
                cell.secondCategoryLabel.hidden = true
                cell.separatorLeft.active = false
            }
            
            print("section 0")
            
        case 1:
            cell.titleLabel.text = String(self.scrapListEnd[row]["title"])
            cell.recruitLabel.text = String(self.scrapListEnd[row]["recruitment"])
            cell.titleLabel.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1.0)
            cell.recruitLabel.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1.0)
            cell.endImage.hidden = false
            cell.endImage.image = UIImage(named: "scrap_info_finish")
            cell.firstCategoryLabel.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1.0)
            cell.recruitNumberLabel.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1.0)
            cell.firstCategoryLabel.text = firstCategoryEnd[row]
            cell.applyButton.enabled = false
            if(self.scrapListEnd[row]["is_apply"].intValue == 1){
                cell.applyButton.setImage(UIImage(named: "scrap_info_button_down"), forState: .Normal)
            }else{
                cell.applyButton.setImage(UIImage(named: "scrap_info_button"), forState: .Normal)
            }
            switch self.firstCategoryEnd[row] {
            case "광고/아이디어/마케팅":
                cell.separatorLeftSecond.active = true
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_idea")
            case "디자인":
                cell.separatorLeftSecond.active = true
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_design")
            case "사진/UCC":
                cell.separatorLeftSecond.active = true
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_video")
            case "게임/소프트웨어":
                cell.separatorLeftSecond.active = true
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_it")
            case "해외":
                cell.separatorLeftSecond.active = true
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_marketing")
            case "기타":
                cell.separatorLeftSecond.active = true
                cell.firstCategoryIcon.image = UIImage(named: "detail_icon_scenario")
            default:
                print("default  section 1 first")
            }
            
            if(secondCategoryEnd[row] != "없음"){
                cell.secondCategoryLabel.text = secondCategoryEnd[row]
                cell.secondCategoryLabel.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1.0)
                cell.separatorLeftSecond.active = true
            }
            switch self.secondCategoryEnd[row] {
            case "광고/아이디어/마케팅":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_idea")
            case "디자인":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_design")
            case "사진/UCC":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_video")
            case "게임/소프트웨어":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_it")
            case "해외":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_marketing")
            case "기타":
                cell.separatorLeft.active = true
                cell.separatorLeftSecond.active = false
                cell.secondCategoryLabel.hidden = false
                cell.secondCategoryIcon.image = UIImage(named: "detail_icon_scenario")
            default:
                cell.secondCategoryIcon.image = UIImage()
                cell.secondCategoryIcon.frame = CGRectMake(0, 0, 0, 0)
                cell.secondCategoryLabel.hidden = true
                cell.secondCategoryLabel.frame = CGRectMake(0, 0, 0, 0)
                cell.separatorLeft.active = false
            }
            
        default:
            print("default section2 second")
        }
        
        
        //신청버튼
        cell.applyButton.addTarget(self, action: #selector(ScrapListViewController.applyAction(_:)), forControlEvents: .TouchUpInside)
        cell.applyButton.tag = self.scrapList![row]["contests_id"].intValue
        
        
        //자세히보기 버튼
        //cell.detailButton.addTarget(self, action: "detailAction:", forControlEvents: .TouchUpInside)
        //cell.detailButton.tag = self.scrapList![row]["contests_id"].intValue
        
        //삭제하기 버튼
        //cell.deleteButton.addTarget(self, action: "deleteAction:", forControlEvents: .TouchUpInside)
        //cell.deleteButton.tag = self.scrapList![row]["contests_id"].intValue

        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
    }
    
    
    
    func detailAction(sender: UIButton){
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! ArticleDetailViewController
        detailViewController.contests_id = sender.tag
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func applyAction(sender: UIButton){
        
        let contests_id:Int = sender.tag
        print(contests_id)
        let alertController = UIAlertController(title: "신청하기", message: "신청하시겠습니까?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "취소", style: .Destructive, handler: nil)
        let okAction = UIAlertAction(title: "신청", style: .Default, handler: {(action)
            in
            Alamofire.request(.POST, "http://come.n.get.us.to/contests/\(contests_id)/join", headers: self.header).responseJSON{
                response in
                if let responseVal = response.result.value{
                    let alertController2 = UIAlertController(title: "신청결과", message: responseVal["msg"]!! as? String, preferredStyle: .Alert)
                    let okAction2 = UIAlertAction(title: "완료", style: .Default, handler: { (action)
                        in
                        self.loadData()
                    })
                    alertController2.addAction(okAction2)
                    self.presentViewController(alertController2, animated: true, completion: nil)
                }
            }
            
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteAction(sender: UIButton) {
        let contests_id:Int = sender.tag
        Alamofire.request(.DELETE, "http://come.n.get.us.to/clips/\(contests_id)", headers: header).responseJSON{
            response in
            if let responseVal = response.result.value{
                let responseJSON = JSON(responseVal)
        
                let msg:String = responseJSON["msg"].stringValue
                let alertController = UIAlertController(title: "찜삭제", message: msg, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
                (action) in
                    self.loadData()
                    self.tableView.reloadData()
                })
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    func loadData(){
        let amount:Int = 20
        var jsonArrayNow:[JSON] = []
        var jsonArrayEnd:[JSON] = []
        Alamofire.request(.GET, "http://come.n.get.us.to/clips",headers: header ,parameters: ["amount": amount]).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                self.scrapList = json["data"]
                self.firstCategoryEnd.removeAll()
                self.secondCategoryEnd.removeAll()
                self.firstCategoryNow.removeAll()
                self.secondCategoryNow.removeAll()
                for (key : subJson):(String, JSON) in self.scrapList!{
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
            }
            self.scrapListNow = JSON(jsonArrayNow)
            self.scrapListEnd = JSON(jsonArrayEnd)
            print(self.firstCategoryEnd)
            print(self.secondCategoryEnd)
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            
            print("reload함수 실행.")
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
