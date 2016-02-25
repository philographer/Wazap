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


class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    
    /**
     @ Outlet
    */
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    
    /**
     @ SideButton
    */
    @IBAction func showMeMyMenu () {
        if let container = self.so_containerViewController {
            container.isLeftViewControllerPresented = true
        }
    }

    /**
     @ 검색 버튼
    */
    @IBAction func searchButton(sender: AnyObject) {

    }
    
    /**
     @ 스크랩 버튼
    */
    @IBAction func scrapButton(sender: UIButton)
    {
        print("스크랩버튼")
        
        Alamofire.request(.POST, "http://come.n.get.us.to/clips/\(sender.tag)", parameters: ["access_token": FBSDKAccessToken.currentAccessToken().tokenString as String]).responseJSON{
            response in
            if let JSON = response.result.value{
                let alertController = UIAlertController(title: "찜하기", message: JSON["msg"] as? String, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    var contestList:AnyObject? = []
    var dueDays:[String]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView 보여주기
        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self
        
        /**
         @ 글쓰기 버튼 추가
        */
        let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width - 70, y: self.view.frame.size.height - 70), size: CGSize(width: 50, height: 50)))
        button.layer.zPosition = 2
        button.backgroundColor = UIColor.whiteColor()
        button.setImage(UIImage(named: "pen.png"), forState: UIControlState.Normal)
        button.addTarget(self, action: "writeButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.view.addSubview(button)
    }
    
    func writeButton(sender:UIButton){
        let writeController = self.storyboard?.instantiateViewControllerWithIdentifier("writeViewController")
        self.presentViewController(writeController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Facebook Id 얻어오기
        Alamofire.request(.GET, "http://come.n.get.us.to/contests", parameters: ["amount": 30]).responseJSON{
            response in
            if let JSON = response.result.value{
                self.contestList = JSON["data"]!!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contestList!.count
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =
        self.tableView.dequeueReusableCellWithIdentifier(
            "MainTableCell", forIndexPath: indexPath)
            as! MainTableViewCell
   
        let row = indexPath.row
        
        //var formattedDay : String?
        
        //날짜 String으로 변환
        if let dayString:String = self.contestList![row]["period"] as? String{
            //String을 NSDate로 변환
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            if let formattedDate = formatter.dateFromString(dayString){
                //앞의 자리수로 자르고 day라벨에 집어넣기
                formatter.dateFormat = "yyyy-MM-dd"
                cell.day.text = formatter.stringFromDate(formattedDate)
                
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
        
        //cell.day.text = formattedDay
        
        cell.dueTime.text = "X 분전"
        cell.articleTitle.text = self.contestList![row]["title"] as? String
        cell.hostName.text = self.contestList![row]["hosts"] as? String
        cell.category.text = self.contestList![row]["categories"] as? String
        cell.scrapButton.tag = self.contestList![row]["contests_id"] as! Int
        cell.scrapButton.addTarget(self, action: "scrapButton:", forControlEvents: .TouchUpInside)
        
        
        return cell
    }
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowArticleDetail"{

            let detailViewController = segue.destinationViewController as! ArticleDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row:Int = myIndexPath!.row
            detailViewController.contests_id = self.contestList![row]["contests_id"] as? Int
            
            
            //write 버튼 숨기기
        }
    }

}
