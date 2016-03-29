//
//  MainTableViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 19..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import Dropper


class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    
    /**
     @ Outlet, Variables
    */
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var categoryButton: UIButton!
    
    
    
    var contestList:JSON = [] //API에서 불러온 공모전 리스트
    var dueDays:[String]? = [] //D-Day 계산을 위한 배열
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    let dropper = Dropper(width: 75, height: 200)
    
    /**
     @ 뷰 로드
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var titleView : UIImageView
        // set the dimensions you want here
        titleView = UIImageView(frame:CGRectMake(0, 0, 50, 50))
        // Set how do you want to maintain the aspect
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "detail_title_banner-1")
        self.navigationItem.titleView = titleView
        print(header)
        //print(FBSDKAccessToken.currentAccessToken().tokenString)
        //margin
        //self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    
    /**
     @ View Appear
     */
    override func viewWillAppear(animated: Bool) {
        
        
        
        //Contest ReLoad
        Alamofire.request(.GET, "http://come.n.get.us.to/contests",headers: header ,parameters: ["amount": 30]).responseJSON{
            response in
            if let responseVal = response.result.value{
                
                let jsonList:JSON = JSON(responseVal)
                
                self.contestList = jsonList["data"]
                //TableView 소스
                self.tableView.delegate = self
                self.tableView.dataSource = self
                //TabBar 소스
                self.tabBar.delegate = self
                self.tableView.reloadData()
            }
        }
        
        //글쓰기 버튼 추가

        let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: self.view.frame.size.height - 100), size: CGSize(width: 80, height: 80)))
        button.layer.zPosition = 2
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = UIColor.whiteColor()
        button.setImage(UIImage(named: "writing_icon"), forState: UIControlState.Normal)
        button.tag = 1000
        button.addTarget(self, action: #selector(MainTableViewController.writeButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.view.addSubview(button)
    }
    
    /**
     @ 뷰 사라짐
     */
    override func viewWillDisappear(animated: Bool) {
        //Tag == 1000인 SubView를 찾아서 제거( 글쓰기 버튼 제거)
        let subViews = self.navigationController?.view.subviews
        for subview in subViews!{
            if subview.tag == 1000{
                subview.removeFromSuperview()
            }
        }
        //print("뷰 disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     @ Table, TabBar
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contestList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =
        self.tableView.dequeueReusableCellWithIdentifier(
            "MainTableCell", forIndexPath: indexPath)
            as! MainTableViewCell
   
        let row = indexPath.row
        
        //날짜 String으로 변환
        if let dayString:String = self.contestList[row]["period"].stringValue{
            //String을 NSDate로 변환
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            if let formattedDate = formatter.dateFromString(dayString){
                //앞의 자리수로 자르고 day라벨에 집어넣기
                formatter.dateFormat = "yyyy-MM-dd"
                //cell.day.text = formatter.stringFromDate(formattedDate)
                //D-day 표시
                let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                if (toDate > 0){
                    cell.dueDay.text = "D-" + String(Int(toDate))
                }
                else{
                    cell.dueDay.text = "마감"
                }
                
            }
        }
        
        cell.nowNumber.text = self.contestList[row]["appliers"].stringValue
        cell.maxNumber.text = self.contestList[row]["recruitment"].stringValue
        
        cell.articleTitle.text = self.contestList[row]["title"].stringValue
        cell.hostName.text = self.contestList[row]["hosts"].stringValue
        cell.category.text = self.contestList[row]["categories"].stringValue
        cell.scrapButton.tag = self.contestList[row]["contests_id"].intValue
        cell.scrapButton.addTarget(self, action: #selector(MainTableViewController.scrapButton(_:)), forControlEvents: .TouchUpInside)
        
        let is_clip = self.contestList[row]["is_clip"].boolValue
        
        if(is_clip == true){
            cell.scrapButton.setImage(UIImage(named: "heart2"), forState: .Normal)
            (UIImage(named: "writing_icon"), forState: UIControlState.Normal)
        }
        
        
        //셀 margin
        
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor( red: 243/255, green: 243/255, blue:243/255, alpha: 1.0 ).CGColor
        cell.layer.borderWidth = 2.0
        
        return cell
    }
    
    /**
     @ TabBar
    */
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let index = item.tag
        
        switch index{
        case 1:
            self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        case 2:
            self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contestsListScreen")
        default:
            self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
            break
        }
    }
    
    /**
     @ PrepareForSegue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowArticleDetail"{
            let detailViewController = segue.destinationViewController as! ArticleDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row:Int = myIndexPath!.row
            detailViewController.contests_id = self.contestList[row]["contests_id"].intValue
            //print("prepare for segue: applies_id: \(detailViewController.applies_id)")
            
            //상세정보 받아옴
            
            var content_writer: Int?
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
                    detailViewController.titleLabel.text = json["data"]["title"].stringValue
                    detailViewController.hostsLabel.text = json["data"]["hosts"].stringValue
                    detailViewController.categoryLabel.text = String(detailViewController.categoryArr)
                    detailViewController.recruitmentLabel.text = json["data"]["recruitment"].stringValue
                    detailViewController.writerLabel.text = json["data"]["cont_writer"].stringValue
                    detailViewController.coverLabel.text = json["data"]["cover"].stringValue
                    detailViewController.appliersLabel.text = json["data"]["appliers"].stringValue
                    detailViewController.kakaoLabel.text = json["data"]["kakao_id"].stringValue
                    
                    //content_writer 값 할당
                    content_writer = json["data"]["cont_writer"].intValue
                    
                    //!! 글쓴이가 아니면 More버튼을 숨기고 마감하기 버튼도 숨기고 신청하기버튼 추가
                    if (content_writer! != Int(FBSDKAccessToken.currentAccessToken().userID)){
                        //신청하기 버튼 추가
                        let button = UIButton(type: UIButtonType.System) as UIButton
                        button.frame = CGRect(x: 0, y: detailViewController.view.frame.size.height / 12 * 11, width: detailViewController.view.frame.size.width, height: detailViewController.view.frame.size.height / 12)
                        button.backgroundColor = UIColor(colorLiteralRed: 127/255, green: 127/255, blue: 127/255, alpha: 0.5)
                        button.setTitle("신청하기", forState: .Normal)
                        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                        button.titleLabel!.font = UIFont.boldSystemFontOfSize(15.0)
                        button.addTarget(detailViewController, action: #selector(detailViewController.applyTouch(_:)), forControlEvents: .TouchUpInside)
                        button.tag = 1004
                        detailViewController.view.addSubview(button)
                        
                        //더보기, 마감하기 버튼 없애기
                        detailViewController.moreButton.title = ""
                        detailViewController.moreButton.enabled = false
                        detailViewController.closeButton.hidden = true
                        
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

    }
    
    /**
     @ SideButton Action
    */
    @IBAction func showMeMyMenu () {
        if let container = self.so_containerViewController {
            container.isLeftViewControllerPresented = true
        }
    }
    
    /**
     @ 스크랩 버튼 Action
    */
    @IBAction func scrapButton(sender: UIButton)
    {
        
        print("스크랩버튼")
        print(sender.tag)
        
        var is_clip:Bool = false
        
        //찜인지 아닌지 찾음
        for (_,subJson):(String, JSON) in self.contestList {
            
            if(subJson["contests_id"].intValue == sender.tag){
                is_clip = subJson["is_clip"].boolValue
            }
        }
        print(is_clip)
        
        if(is_clip){
            //찜 삭제
            Alamofire.request(.DELETE, "http://come.n.get.us.to/clips/\(sender.tag)", headers: header).responseJSON{
                response in
                if let JSON = response.result.value{
                    let alertController = UIAlertController(title: "찜삭제", message: JSON["msg"] as? String, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(action) in
                        for i in 0  ..< self.contestList.count {
                            if(self.contestList[i]["contests_id"].intValue == sender.tag){
                                self.contestList[i]["is_clip"].boolValue = !self.contestList[i]["is_clip"].boolValue
                            }
                        }

                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    sender.setImage(UIImage(named: "heart1"), forState: .Normal)
                }
            }
            
            
        }
        else{
            //찜하기
            Alamofire.request(.POST, "http://come.n.get.us.to/clips/\(sender.tag)", headers: header).responseJSON{
                response in
                if let JSON = response.result.value{
                    let alertController = UIAlertController(title: "찜하기", message: JSON["msg"] as? String, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(action) in
                        for i in 0  ..< self.contestList.count {
                            if(self.contestList[i]["contests_id"].intValue == sender.tag){
                                self.contestList[i]["is_clip"].boolValue = !self.contestList[i]["is_clip"].boolValue
                            }
                        }
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    sender.setImage(UIImage(named: "heart2"), forState: .Normal)
                }
            }
        }
    }
    
    /**
     @ 글쓰기 버튼 Function
     */
    func writeButton(sender:UIButton){
        let writeController = self.storyboard?.instantiateViewControllerWithIdentifier("writeViewController")
        self.presentViewController(writeController!, animated: true, completion: nil)
    }
    
    /**
     @ 검색 버튼 Function
    */
    @IBAction func searchButton(sender: AnyObject) {
        
    }
    
    /**
     @ 드랍다운
    */
    @IBAction func dropdownAction(sender: AnyObject) {
        if dropper.status == .Hidden {
            dropper.items = ["전체","광고·아이디어·마케팅", "디자인", "사진·UCC", "게임·소프트웨어", "해외", "ETC"]
            dropper.theme = Dropper.Themes.White
            dropper.delegate = self
            dropper.cornerRadius = 3
            dropper.showWithAnimation(0.15, options: Dropper.Alignment.Center, button: categoryButton)
        } else {
            dropper.hideWithAnimation(0.1)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (dropper.hidden == false) { // Checks if Dropper is visible
            dropper.hideWithAnimation(0.1) // Hides Dropper
        }
    }

    
    

}

/**
 @ 드랍다운
 */
extension MainTableViewController: DropperDelegate {
    func DropperSelectedRow(path: NSIndexPath, contents: String) {
        categoryButton.setTitle("\(contents)", forState: .Normal)
        
        let content = "\(contents)"
        var category = ""
        switch content {
            case "전체":
                category = "all"
            case "광고·아이디어·마케팅":
                category = "광고"
            case "디자인":
                category = "디자인"
            case "사진·UCC":
                category = "사진"
            case "게임·소프트웨어":
                category = "게임"
            case "해외":
                category = "해외"
            case "ETC":
                category = "[\"ETC\"]"
            default:
                category = "all"
        }
        
        print(category)
        
        Alamofire.request(.GET, "http://come.n.get.us.to/contests",headers: header ,parameters: ["amount": 30]).responseJSON{
            response in
            if let responseVal = response.result.value{
                
                let jsonList:JSON = JSON(responseVal)
                var jsonArray:[JSON] = []

                for (key : subJson):(String, JSON) in jsonList["data"]{
                    if(category == "all"){
                        jsonArray.append(subJson.1)
                        print(subJson.1["categories"].stringValue)
                    }
                    else if(subJson.1["categories"].stringValue.containsString(category)){
                        jsonArray.append(subJson.1)
                        print(subJson.1)
                    }
                }
                
                self.contestList = JSON.null
                self.contestList = JSON(jsonArray)
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
        
        
        //
        
        
        // self.tableView.reloadData()
        // self.contestList 변경
    }
}

