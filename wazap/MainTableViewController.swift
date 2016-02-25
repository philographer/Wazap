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
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBAction func showMeMyMenu () {
        if let container = self.so_containerViewController {
            container.isLeftViewControllerPresented = true
        }
    }
    
    @IBAction func searchButton(sender: AnyObject) {

    }
    
    var contestList:AnyObject? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView 보여주기
        //tableView.delegate = self
        //tableView.dataSource = self
        tabBar.delegate = self
        
        let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 - 25, y: self.view.frame.size.height - 70), size: CGSize(width: 50, height: 50)))
        button.layer.zPosition = 2
        button.backgroundColor = UIColor.whiteColor()
        button.setImage(UIImage(named: "pen.png"), forState: UIControlState.Normal)
    }
    
    func writeButton(sender:UIButton){
        print("WriteButton Touched")
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
                print(toDate)
                
            }
        }
        
        //cell.day.text = formattedDay
        
        cell.dueTime.text = "X 분전"
        cell.articleTitle.text = self.contestList![row]["title"] as? String
        cell.hostName.text = self.contestList![row]["hosts"] as? String
        cell.category.text = self.contestList![row]["categories"] as? String
        
        return cell
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowArticleDetail"{

            //let detailViewController = segue.destinationViewController as! ArticleDetailViewController
            //let myIndexPath = self.tableView.indexPathForSelectedRow
            //let row:Int = myIndexPath!.row
            
            //print(row)
            //print(articleTitleArr[row])
            
            /*
            detailViewController.articleTitleLabelText = self.contestList![row]["title"] as? String
            detailViewController.dueDayLabelText = self.contestList![row]["title"] as? String
            detailViewController.organizerLabelText = self.contestList![row]["title"] as? String
            detailViewController.categoryLabelText = self.contestList![row]["title"] as? String
            detailViewController.recruitNumberLabelText = self.contestList![row]["title"] as? String
            detailViewController.nameListLabelText = self.contestList![row]["title"] as? String
            detailViewController.nowNumberLabelText = self.contestList![row]["title"] as? String
            detailViewController.hostNameLabelText = self.contestList![row]["title"] as? String
            detailViewController.introLabelText = self.contestList![row]["title"] as? String
            */
            
            
        }
    }

}
