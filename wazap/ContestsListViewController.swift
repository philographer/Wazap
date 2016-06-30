//
//  ContestsListViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 25..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftyJSON
import Alamofire

class ContestsListViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {

    
    /**
     @ Outlet
    */
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contestsLine: UIImageView!
    
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    var contestList:JSON = JSON.null
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var titleView : UIImageView
        // set the dimensions you want here
        titleView = UIImageView(frame:CGRectMake(0, 0, 50, 50))
        // Set how do you want to maintain the aspect
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "detail_title_banner-4")
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //self.tabBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .None
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: true)

        
        
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        Alamofire.request(.GET, "http://come.n.get.us.to/weekly_list", parameters: ["amount" : 10], headers: header).responseJSON{
            response in
            if let responseVal = response.result.value{
                let data = JSON(responseVal)
                let json = data["data"]
                self.contestList = json
                //print(self.contestList)
                self.tableView.reloadData()
            }
        }
        
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let path = self.tableView.indexPathForSelectedRow!
        let row = path.row
        
        if segue.identifier == "ShowContestDetail"{
            print("준비")
            let destController = segue.destinationViewController as! ContestsDetailViewController
            destController.contestTitle = self.contestList[row]["TITLE"].stringValue
            destController.tag = self.contestList[row]["TAG"].stringValue
            destController.hosting = self.contestList[row]["HOSTING"].stringValue
            destController.date = self.contestList[row]["START_DATE"].stringValue + "~" + self.contestList[row]["DEADLINE_DATE"].stringValue
            destController.target = self.contestList[row]["TARGET"].stringValue
            destController.benefit = self.contestList[row]["BENEFIT"].stringValue
            destController.prize = self.contestList[row]["TOTALPRIZE"].stringValue
            destController.image = self.contestList[row]["IMG"].stringValue
            destController.homepage = self.contestList[row]["HOMEPAGE"].stringValue
            
            if let dayString:String = self.contestList[row]["DEADLINE_DATE"].stringValue{
                //String을 NSDate로 변환
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                if let formattedDate = formatter.dateFromString(dayString){
                    //앞의 자리수로 자르고 day라벨에 집어넣기
                    formatter.dateFormat = "yyyy-MM-dd"
                    //cell.day.text = formatter.stringFromDate(formattedDate)
                    //D-day 표시
                    let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                    if (toDate > 0){
                        destController.dueDay = "D-" + String(Int(toDate))
                    }
                    else{
                        destController.dueDay = "마감"
                    }
                    
                }
            }
            
            print(self.contestList[row])
            /*
            destController.titleLabel.text = self.contestList[row]["TITLE"].stringValue
            destController.tagLabel.text = self.contestList[row]["TAG"].stringValue
            destController.hostingLabel.text = self.contestList[row]["HOSTING"].stringValue
            destController.dateLabel.text =
            destController.targetLabel.text = self.contestList[row]["TARGET"].stringValue
            destController.benefitLabel.text = self.contestList[row]["BENEFIT"].stringValue
            destController.prizeLabel.text = self.contestList[row]["TOTALPRIZE"].stringValue
            destController.homepageLabel.text = self.contestList[row]["HOMEPAGE"].stringValue
            destController.imageView.kf_setImageWithURL(NSURL(string: self.contestList[row]["IMG"].stringValue)!)
            
            
            //D - Day 로직
            //날짜 String으로 변환 Due Day Logic
            
            */
            
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("tabBar Clicked")
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contestList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("contestsCell") as! ContestsTableViewCell
        let row = indexPath.row
        
        cell.titleLabel.text = self.contestList[row]["TITLE"].stringValue
        cell.hostLabel.text = self.contestList[row]["HOSTING"].stringValue
        
        cell.dateLabel.text = self.contestList[row]["START_DATE"].stringValue + "~" + self.contestList[row]["DEADLINE_DATE"].stringValue
        
        //날짜 String으로 변환 Due Day Logic
        if let dayString:String = self.contestList[row]["DEADLINE_DATE"].stringValue{
            //String을 NSDate로 변환
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let formattedDate = formatter.dateFromString(dayString){
                //앞의 자리수로 자르고 day라벨에 집어넣기
                formatter.dateFormat = "yyyy-MM-dd"
                //cell.day.text = formatter.stringFromDate(formattedDate)
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
        
        let photoUrl = self.contestList[row]["IMG"].stringValue
        cell.contestImage.kf_setImageWithURL(NSURL(string: photoUrl)!)
        
        //Tag, category, 카테고리 찾기
        let category = String(self.contestList[row]["TAG"].stringValue.characters.split(",")[0])
        print(category)
        
        switch category {
        case "광고/아이디어":
            cell.categoryImage.image = UIImage(named: "list_icon_advertising_word")
        case "디자인/플래시":
            cell.categoryImage.image = UIImage(named: "list_icon_design_word")
        case "브랜드/네이밍":
            cell.categoryImage.image = UIImage(named: "list_icon_brand_word")
        case "마케팅":
            cell.categoryImage.image = UIImage(named: "list_icon_marketing_word")
        case "사진/영상/UCC":
            cell.categoryImage.image = UIImage(named: "list_icon_photo_word")
        case "체험기/사용기":
            cell.categoryImage.image = UIImage(named: "list_icon_experience_word")
        case "학술/논문":
            cell.categoryImage.image = UIImage(named: "list_icon_thesis_word")
        case "예체능":
            cell.categoryImage.image = UIImage(named: "list_icon_art_word")
        case "문학/시나리오":
            cell.categoryImage.image = UIImage(named: "list_icon_literature_word")
        case "건축/인테리어":
            cell.categoryImage.image = UIImage(named: "list_icon_architecture_word")
        case "만화/캐릭터":
            cell.categoryImage.image = UIImage(named: "list_icon_comic_word")
        case "게임/소프트웨어":
            cell.categoryImage.image = UIImage(named: "list_icon_word")
        case "유사공모전":
            cell.categoryImage.image = UIImage(named: "list_icon_similar_word")
        case "해외":
            cell.categoryImage.image = UIImage(named: "list_icon_global_word")
        default:
            break
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 255.0
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //cell.contentView.backgroundColor = UIColor.clearColor()
        
        cell.contentView.backgroundColor = UIColorFromRGB(0xF4F4F4)
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, 235))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
    }
    
    
    
    /**
     @ 사이드 버튼
    */
    @IBAction func menuButton(sender: AnyObject) {
        self.so_containerViewController!.isSideViewControllerPresented = true
    }
    @IBAction func recruitButton(sender: AnyObject) {
        self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
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

