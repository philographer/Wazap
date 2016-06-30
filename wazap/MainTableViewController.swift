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
    @IBOutlet weak var recruitTab: UITabBarItem!
    @IBOutlet weak var contestsListTab: UITabBarItem!
    @IBOutlet weak var accordianButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet var thisView: UIView!
    @IBOutlet var innerView: UIView!
    

    var contestList:JSON = [] //API에서 불러온 공모전 리스트
    var firstCategoryList:[String] = []
    var secondCategoryList:[String] = []
    var dueDays:[String]? = [] //D-Day 계산을 위한 배열
    var header :[String:String] = [:]
    let dropper = Dropper(width: 150, height: 300)
    
    
    var writeButton:UIButton?
    var alphaSubview:UIView?
    var navigationAlphaSubview:UIView?
    
    /**
     @ 뷰 로드
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         @ 타이틀에 와잡 이미지 추가
         */
        
        
        
        
        var titleView : UIImageView
        titleView = UIImageView(frame:CGRectMake(0, 0, 50, 50))
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "detail_title_banner-4")
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //self.navigationItem.titleView?.contentMode = .ScaleAspectFit
        //self.navigationItem.titleView = UIImageView(image: UIImage(named: "detail_title_banner-4"))
        
        
        /**
         @ 아코디언 버튼에 이벤트 추가
         */
        accordianButton.addTarget(self, action: #selector(self.dropdownAction(_:)), forControlEvents: .TouchUpInside)
        
        /**
         @ Dropper Setting
         */
        dropper.items = ["전체 모집글","광고·아이디어·마케팅", "디자인", "사진·UCC", "게임·소프트웨어", "해외", "ETC"]
        dropper.theme = Dropper.Themes.White
        dropper.delegate = self
        dropper.cornerRadius = 3
        dropper.refresh()
        
        print(self.so_containerViewController)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
        self.categoryBtn.layer.addBorder(UIRectEdge.Bottom, color: UIColorFromRGB(0x727272), thickness: 0.5)
        self.categoryBtn.layer.addBorder(UIRectEdge.Top, color: UIColorFromRGB(0x727272), thickness: 0.5)
        self.categoryBtn.layer.addBorder(UIRectEdge.Left, color: UIColorFromRGB(0x727272), thickness: 0.5)
        
       
        self.categoryButton.layer.addBorder(UIRectEdge.Top, color: UIColorFromRGB(0x727272), thickness: 0.5)
        self.categoryButton.layer.addBorder(UIRectEdge.Bottom, color: UIColorFromRGB(0x727272), thickness: 0.5)
        self.categoryButton.layer.addBorder(UIRectEdge.Right, color: UIColorFromRGB(0x727272), thickness: 0.5)
        
        
        
        //self.categoryButton.layer.addBorder(UIRectEdge.Right, color: UIColorFromRGB(0x727272), thickness: 0.5)
        
        //self.categoryButton.layer.addBorder(UIRectEdge.Left, color: UIColorFromRGB(0x727272), thickness: 0.5)
        
        //self.accordianButton.layer.addBorder(UIRectEdge.Left, color: UIColorFromRGB(0x727272), thickness: 0.5)
        
        
    }
    
    /**
     @ View Appear
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        guard (FBSDKAccessToken.currentAccessToken() != nil) else {
            let mainStoryboard: UIStoryboard = self.storyboard!
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("loginViewController")
            UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
            return
        }
        
        self.header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
        
        
        //Contest ReLoad
        self.reloadData()
        
        //글쓰기 버튼 추가
        writeButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: self.view.frame.size.height - 100), size: CGSize(width: 80, height: 80)))
        writeButton!.layer.zPosition = 1
        writeButton!.layer.cornerRadius = 0.5 * writeButton!.bounds.size.width
        writeButton!.backgroundColor = UIColor.whiteColor()
        writeButton!.setImage(UIImage(named: "write_button_2"), forState: UIControlState.Normal)
        writeButton!.tag = 1000
        writeButton!.layer.shadowColor = UIColor.blackColor().CGColor
        //writeButton!.layer.shadowOffset = CGSize(width: 2.0, height: 0.5)
        //writeButton!.layer.shadowOpacity = 1;
        //writeButton!.layer.shadowRadius = 10;
        writeButton!.layer.shadowOffset = CGSizeMake(0, 7)
        writeButton!.layer.shadowRadius = 3.5
        writeButton!.layer.shadowOpacity = 0.3
        writeButton!.addTarget(self, action: #selector(MainTableViewController.writeButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.view.addSubview(writeButton!)
        
        
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
        return self.contestList.count - 1
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
                    cell.dueDay.text = "D  -  " + String(Int(toDate)) + "    "
                }
                else{
                    cell.dueDay.text = "마감      "
                }
                
            }
        }
        
        //D-day Border 둥글게 추가
        //let backImage = UIImage(named: "box_icon.9")
        //let resizablebackImage = backImage?.resizableImageWithCapInsets(UIEdgeInsets(top:0,left:50,bottom:0,right:50))
        //cell.contTitle.backgroundColor = UIColor(patternImage:resizablebackImage!)
        
        
        //조금 이상한 모양
        cell.dueDay.layer.borderColor = UIColorFromRGB(0x0057FF).CGColor
        cell.dueDay.layer.borderWidth = 0.5
        cell.dueDay.layer.cornerRadius = 12
        cell.dueDay.layer.masksToBounds = true
        
        
        
        cell.nowNumber.text = self.contestList[row]["appliers"].stringValue
        cell.maxNumber.text = self.contestList[row]["recruitment"].stringValue
        cell.location.text = self.contestList[row]["cont_locate"].stringValue
        cell.articleTitle.text = self.contestList[row]["title"].stringValue
        cell.contTitle.text = self.contestList[row]["cont_title"].stringValue
        cell.hostName.text = self.contestList[row]["hosts"].stringValue
        cell.firstCategoryLabel.text = self.firstCategoryList[row]
        cell.secondCategoryLabel.text = self.secondCategoryList[row]
        
        
        switch self.firstCategoryList[row] {
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
        case "ETC":
            cell.firstCategoryIcon.image = UIImage(named: "detail_icon_scenario")
        default:
            break
        }
        
        switch self.secondCategoryList[row] {
        case "광고/아이디어/마케팅":
            cell.secondCategoryLabel.hidden = false
            cell.secondCategoryIcon.image = UIImage(named: "detail_icon_idea")
        case "디자인":
            cell.secondCategoryLabel.hidden = false
            cell.secondCategoryIcon.image = UIImage(named: "detail_icon_design")
        case "사진/UCC":
            cell.secondCategoryLabel.hidden = false
            cell.secondCategoryIcon.image = UIImage(named: "detail_icon_video")
        case "게임/소프트웨어":
            cell.secondCategoryLabel.hidden = false
            cell.secondCategoryIcon.image = UIImage(named: "detail_icon_it")
        case "해외":
            cell.secondCategoryLabel.hidden = false
            cell.secondCategoryIcon.image = UIImage(named: "detail_icon_marketing")
        case "ETC":
            cell.secondCategoryLabel.hidden = false
            cell.secondCategoryIcon.image = UIImage(named: "detail_icon_scenario")
        default:
            cell.secondCategoryIcon.image = UIImage()
            cell.secondCategoryLabel.hidden = true
        }
        
        
        
        
        cell.scrapButton.tag = self.contestList[row]["contests_id"].intValue
        cell.scrapButton.addTarget(self, action: #selector(MainTableViewController.scrapButton(_:)), forControlEvents: .TouchUpInside)
        
        let is_clip = self.contestList[row]["is_clip"].boolValue
        
        if(is_clip == true){
            cell.scrapButton.setImage(UIImage(named: "heart2"), forState: .Normal)
        }
        else{
            cell.scrapButton.setImage(UIImage(named: "heart1"), forState: .Normal)
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
            self.so_containerViewController?.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        case 2:
            self.so_containerViewController?.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contestsListScreen")
        default:
            self.so_containerViewController?.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
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
            let contest = self.contestList[row]
            let content_writer = contest["cont_writer"].intValue
            detailViewController.contests_id = contest["contests_id"].intValue
            detailViewController.contests = contest
            
            
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
                        detailViewController.profileImage.kf_setImageWithURL(profileURL, completionHandler:{
                            (image, error, cacheType, imageURL) -> () in
                            detailViewController.profileImage.image = detailViewController.profileImage.image?.af_imageRoundedIntoCircle()
                        })
                    }
                case .Failure(let error):
                    print(error)
                    detailViewController.profileImage.image = UIImage(named: "default-user2")!.af_imageRoundedIntoCircle()
                }
            }
            
            
            
            
            /*
            
            
            
            //D-day 변환 로직
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
                        detailViewController.dueDayLabel.text = "D - " + String(Int(toDate))
                    }
                    else{
                        detailViewController.dueDayLabel.text = "마감"
                    }
                    
                }
            }
            
            
            /*
            Alamofire.request(.GET, "http://come.n.get.us.to/contests/\(contests_id)", headers: header, encoding: .JSON).responseJSON{
                response in
                if let responseVal = response.result.value{
                    
                    print(responseVal)
                    //받아온 정보 contests에 할당
                    let json = JSON(responseVal)
                    
                    guard json["result"].boolValue else{
                        print("에러발생" + json["msg"].stringValue)
                        return
                    }
                }
            }
            */
            */
        }
 
    }
    
    /**
     @ SideButton Action
    */
    @IBAction func showMeMyMenu () {
        self.so_containerViewController?.isSideViewControllerPresented = true
    }
    
    /**
     @ 스크랩 버튼 Action
    */
    @IBAction func scrapButton(sender: UIButton)
    {
        var is_clip:Bool = false
        //찜인지 아닌지 찾음
        for (_,subJson):(String, JSON) in self.contestList {
            
            if(subJson["contests_id"].intValue == sender.tag){
                is_clip = subJson["is_clip"].boolValue
            }
        }
        
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
    
    
    @IBAction func recruitButton(sender: AnyObject) {
        self.so_containerViewController?.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
    }
    
    
    @IBAction func contestsButton(sender: AnyObject) {
        self.so_containerViewController?.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contestsListScreen")
    }
    
    /**
     @ 글쓰기 버튼 Function
     */
    func writeButton(sender:UIButton){
        let writeController = self.storyboard?.instantiateViewControllerWithIdentifier("writeViewController")
        self.presentViewController(writeController!, animated: true, completion: nil)
    }
    
    /**
     @ 검색 버튼 Functionf
    */
    @IBAction func searchButton(sender: AnyObject) {
        
    }
    
    
    @IBAction func listButton(sender: AnyObject) {
        self.so_containerViewController?.topViewController = self.storyboard!.instantiateViewControllerWithIdentifier("contestsWeekly")
    }
    
    
    /**
     @ 드랍다운
    */
    @IBAction func dropdownAction(sender: AnyObject) {
        if dropper.status == .Hidden { //dropper가 안 보일때
            //view에 subView추가
            self.alphaSubview = UIView(frame: (UIApplication.sharedApplication().keyWindow?.frame)!)
            self.alphaSubview!.backgroundColor = UIColor.blackColor()
            self.alphaSubview!.alpha = 0.0
            self.innerView.addSubview(self.alphaSubview!)
            
            
            self.dropper.showWithAnimation(0.1, options: .Center, button: self.categoryButton)
            
            self.view.bringSubviewToFront(self.innerView)
            self.innerView.bringSubviewToFront(self.dropper)
            
            print("tag is \(self.dropper.superview!.tag)")

            //navigationView에 subView 추가
            
            let nav = self.navigationController!.navigationBar.frame
            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
            let rect = CGRect(x: nav.origin.x, y: 0, width: nav.width, height: nav.height+0.5 + statusBarHeight)
            self.navigationAlphaSubview = UIView(frame: rect)
            self.navigationAlphaSubview!.backgroundColor = UIColor.blackColor()
            self.navigationAlphaSubview!.alpha = 0.0
            self.navigationController!.view.addSubview(self.navigationAlphaSubview!)
            UIView.animateWithDuration(0.2, animations: {
                self.alphaSubview?.alpha = 0.5
                self.navigationAlphaSubview!.alpha = 0.5
                self.writeButton?.alpha = 0
            })
            
        } else { //dropper가 숨겨질때
            dropper.hideWithAnimation(0.1)
            UIView.animateWithDuration(0.2, animations: {
                self.alphaSubview?.alpha = 0.0
                self.writeButton?.alpha = 1
                self.navigationAlphaSubview?.alpha = 0.0
                }, completion: { Void in
                    self.alphaSubview!.removeFromSuperview()
                    self.navigationAlphaSubview!.removeFromSuperview()
            })
            //이 경우가 있음?
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (dropper.status == .Displayed) { // Checks if Dropper is visible
            dropper.hideWithAnimation(0.1)
            UIView.animateWithDuration(0.2, animations: {
                self.alphaSubview?.alpha = 0.0
                self.writeButton?.alpha = 1
                self.navigationAlphaSubview?.alpha = 0.0
                }, completion: { Void in
                    self.alphaSubview!.removeFromSuperview()
                    self.navigationAlphaSubview!.removeFromSuperview()
            })
        }
        print("터치")
    }
    
    func reloadData(){
        Alamofire.request(.GET, "http://come.n.get.us.to/contests",headers: header ,parameters: ["amount": 30]).responseJSON{
            response in
            if let responseVal = response.result.value{
                
                let jsonList:JSON = JSON(responseVal)
                self.contestList = jsonList["data"]
                self.firstCategoryList.removeAll()
                self.secondCategoryList.removeAll()
                //cell for row에 파싱해서 넣으면 버그때문에 여기서!
                for contest in self.contestList {
                    if let wordsInclude = contest.1["categories"].string?.characters.dropFirst().dropLast().split(",").map(String.init){
                        for (index,words) in wordsInclude.enumerate(){
                            switch index{
                            case 0:
                                self.firstCategoryList.append(String(words.characters.dropFirst().dropLast()))
                            case 1:
                                self.secondCategoryList.append(String(words.characters.dropFirst().dropLast()))
                            default:
                                break
                            }
                            
                            if(wordsInclude.count == 1){
                                self.secondCategoryList.append("없음")
                            }
                        }
                    }
                }
                //TableView 소스
                self.tableView.delegate = self
                self.tableView.dataSource = self
                
                //TabBar 소스
                //self.tabBar.delegate = self
                self.tableView.reloadData()
            }
        }
    }
    
    func categoryReloadData(category : String){
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/categories",headers: header ,parameters: ["amount": 30, "category_name": category]).responseJSON{
            response in
            if let responseVal = response.result.value{
                
                let jsonList:JSON = JSON(responseVal)
                self.contestList = jsonList["data"]
                self.firstCategoryList.removeAll()
                self.secondCategoryList.removeAll()
                //cell for row에 파싱해서 넣으면 버그때문에 여기서!
                for contest in self.contestList {
                    if let wordsInclude = contest.1["categories"].string?.characters.dropFirst().dropLast().split(",").map(String.init){
                        for (index,words) in wordsInclude.enumerate(){
                            switch index{
                            case 0:
                                self.firstCategoryList.append(String(words.characters.dropFirst().dropLast()))
                            case 1:
                                self.secondCategoryList.append(String(words.characters.dropFirst().dropLast()))
                            default:
                                break
                            }
                            
                            if(wordsInclude.count == 1){
                                self.secondCategoryList.append("없음")
                            }
                        }
                    }
                }
                //TableView 소스
                self.tableView.delegate = self
                self.tableView.dataSource = self
                
                //TabBar 소스
                //self.tabBar.delegate = self
                self.tableView.reloadData()
            }
        }
    }
    
    func pixelToPoint(px: CGFloat) -> CGFloat {
        let pointsPerInch:CGFloat = 72.0; // see: http://en.wikipedia.org/wiki/Point%5Fsize#Current%5FDTP%5Fpoint%5Fsystem
        let scale:CGFloat = 1; // We dont't use [[UIScreen mainScreen] scale] as we don't want the native pixel, we want pixels for UIFont - it does the retina scaling for us
        var pixelPerInch:CGFloat = 0; // aka dpi
        if (UI_USER_INTERFACE_IDIOM() == .Pad) {
            pixelPerInch = 132 * scale;
        } else if (UI_USER_INTERFACE_IDIOM() == .Phone) {
            pixelPerInch = 163 * scale;
        } else {
            pixelPerInch = 160 * scale;
        }
        let result = px * pointsPerInch / pixelPerInch;
        return result;
    }
}



/**
 @ 드랍다운
 */
extension MainTableViewController: DropperDelegate {
    func DropperSelectedRow(path: NSIndexPath, contents: String) {
        
        UIView.animateWithDuration(0.2, animations: {
            self.navigationAlphaSubview!.alpha = 0.0
            }, completion: {Void in
                self.navigationAlphaSubview!.removeFromSuperview()
        })
        
        self.writeButton?.alpha = 1
        
        categoryButton.setTitle("\(contents)", forState: .Normal)
        let content = "\(contents)"
        var category = ""
        switch content {
        case "전체 모집글":
            category = "전체 모집글"
        case "광고·아이디어·마케팅":
            category = "광고/아이디어/마케팅"
        case "디자인":
            category = "디자인"
        case "사진·UCC":
            category = "사진/UCC"
        case "게임·소프트웨어":
            category = "게임/소프트웨어"
        case "해외":
            category = "해외"
        case "ETC":
            category = "기타"
        default:
            category = "all"
        }
        
        UIView.animateWithDuration(0.2, animations: {self.alphaSubview?.alpha = 0.0}, completion:{ _ in self.alphaSubview?.removeFromSuperview()} )
        
        if category == "전체 모집글"{
            self.reloadData()
        }
        else{
            self.categoryReloadData(category)
        }
        
        
        /*
        Alamofire.request(.GET, "http://come.n.get.us.to/contests",headers: header ,parameters: ["amount": 30]).responseJSON{
            response in
            if let responseVal = response.result.value{
                
                let jsonList:JSON = JSON(responseVal)
                var jsonArray:[JSON] = []

                for (key : subJson):(String, JSON) in jsonList["data"]{
                    if(category == "all"){
                        jsonArray.append(subJson.1)
                        //print(subJson.1["categories"].stringValue)
                    }
                    else if(subJson.1["categories"].stringValue.containsString(category)){
                        jsonArray.append(subJson.1)
                        //print(subJson.1)
                    }
                }
                
                self.contestList = JSON.null
                self.contestList = JSON(jsonArray)
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
        */
        
        //
        
        
        // self.tableView.reloadData()
        // self.contestList 변경
    }
}

public extension UIView{
    func fadeIn(duration duration:NSTimeInterval = 1.0){
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.5
        })
    }
    
    func fadeOut(duration duration:NSTimeInterval = 1.0){
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
        })
    }
}



