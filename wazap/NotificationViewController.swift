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
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //파라미터로 start_id , amount가 있음
    }
    
    override func viewWillAppear(animated: Bool) {
        Alamofire.request(.GET, "http://come.n.get.us.to/alrams",headers: header ,parameters: [:]).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                self.alamList = json["data"]
                print(self.alamList)
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
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
    
    
        let profileString = alamList![row]["profile_img"].stringValue
        let profileURL = NSURL(string: profileString.stringByRemovingPercentEncoding!)!
        
        cell.profilePhoto.kf_setImageWithURL(profileURL, completionHandler:{
            (image, error, cacheType, imageURL) -> () in
            cell.profilePhoto.image = cell.profilePhoto.image?.af_imageRoundedIntoCircle()
        })
        
        /*
        if let data = NSData(contentsOfURL: profileURL)
        {
            cell.profilePhoto.image = UIImage(data: data)?.af_imageRoundedIntoCircle()
        }
        */
        
        
        

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
