//
//  NotificationViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     @ Outlet
    */
    @IBOutlet weak var tableView: UITableView!
    
    /**
     @ Variables
    */
    //더미데이터
    let leftMenu : [String] = ["알림1", "알림2", "알림3"]
    let leftMenu2 : [String] = ["알림3", "알림2", "알림1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let access_token = FBSDKAccessToken.currentAccessToken().tokenString as String
        
        
        Alamofire.request(.GET, "http://come.n.get.us.to/alrams", parameters: ["access_token": access_token, "start_id": 0, "amount": 10]).responseJSON{
            response in
            if let JSON = response.result.value{
                print(JSON["msg"]!)
            }
        }
        
        //파라미터로 start_id , amount가 있음
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("notiCell") as! NotificationTableViewCell
        let row = indexPath.row
        
        if(indexPath.section == 0){
            cell.alarmLabel.text = leftMenu[row]
            cell.profilePhoto.image = UIImage(named: "default-user2")
        }
        else
        {
            cell.alarmLabel.text = leftMenu2[row]
            cell.profilePhoto.image = UIImage(named: "default-user2")
        }
        return cell
    }
    
    /**
     @ 뒤로가기버튼 Action
     */
    @IBAction func backButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
