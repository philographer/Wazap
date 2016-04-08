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
        titleView.image = UIImage(named: "detail_title_banner-1")
        self.navigationItem.titleView = titleView
        
        //self.tabBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        
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
                print(self.contestList)
                self.tableView.reloadData()
            }
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
        cell.startDateLabel.text = self.contestList[row]["START_DATE"].stringValue
        cell.endDateLabel.text = self.contestList[row]["DEADLINE_DATE"].stringValue
        
        let photoUrl = self.contestList[row]["IMG"].stringValue
        
        if let url = NSURL(string: photoUrl), data = NSData(contentsOfURL: url)
        {
            cell.contestImage.image = UIImage(data: data)
        }
        
        
        return cell
    }
    
    /**
     @ 사이드 버튼
    */
    @IBAction func menuButton(sender: AnyObject) {
        if let container = self.so_containerViewController{
            container.isLeftViewControllerPresented = true
        }
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

