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
import SwiftyJSON

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     @ Outlet
    */
    @IBOutlet weak var tableView: UITableView!
    
    /**
     @ Variables
    */
    //더미데이터
    var alamList:JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //파라미터로 start_id , amount가 있음
    }
    
    override func viewWillAppear(animated: Bool) {
        let access_token = FBSDKAccessToken.currentAccessToken().tokenString as String
        Alamofire.request(.GET, "http://come.n.get.us.to/alrams", parameters: ["access_token": access_token, "start_id": 0, "amount": 10]).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                print(json)
                self.alamList = json["data"]
                self.tableView.delegate = self
                self.tableView.dataSource = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alamList!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("notiCell") as! NotificationTableViewCell
        let row = indexPath.row
        
            cell.alarmLabel.text = alamList![row]["msg"].stringValue
            cell.profilePhoto.image = UIImage(named: "default-user2")

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
