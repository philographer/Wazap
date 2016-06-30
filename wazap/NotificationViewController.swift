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
    
    var alamList:JSON = JSON.null
    var dateList:[NSDate] = []
    var dateAlarmList:[[JSON]] = [[]]
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        Alamofire.request(.GET, "http://come.n.get.us.to/alrams",headers: header ,parameters: [:]).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                self.alamList = json["data"]
                
                
                //날짜만 뽑아서 dateList에 없으면 집어넣음
                for (index, subJson) in self.alamList{
                    
                    print(subJson)
                    if let dateString:String = subJson["alramdate"].stringValue{
                        let formatter = NSDateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                        if let formattedDate = formatter.dateFromString(dateString){
                            if !self.dateList.contains(formattedDate){
                                self.dateList.append(formattedDate)
                            }
                        }
                        
                    }
                }
                
                print(self.dateList)
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
        return dateList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        
        var count = 0
        for alarm in self.alamList{
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            let formattedDate = formatter.dateFromString(alarm.1["alramdate"].stringValue)
            
            if(formattedDate == dateList[section]){
                count += 1
            }
        }
        
        return count
    }

    /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let date:NSDate = dateList[section]{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = formatter.stringFromDate(date)
            return formattedDate
        }
    }
    */
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("notiHeaderCell") as! NotificationTableViewHeaderCell
        
        if let date:NSDate = dateList[section]{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM월 dd일 E"
            let formattedDate = formatter.stringFromDate(date)
            
            headerCell.dateLabel.text = formattedDate
            
            return headerCell
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("notiCell") as! NotificationTableViewCell
        let row = indexPath.row
        let myString:NSString = alamList[row]["username"].stringValue + alamList[row]["msg"].stringValue
        var myMutableString = NSMutableAttributedString()
        let size = alamList[row]["username"].string?.characters.count
        let profileString = alamList[row]["profile_img"].stringValue
        let profileURL = NSURL(string: profileString.stringByRemovingPercentEncoding!)!
        let isCheck = alamList[row]["is_check"].boolValue
        
        myMutableString = NSMutableAttributedString(string: myString as String)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorFromRGB(0x0056FF),range: NSRange(location:0,length: size!))
        
        cell.alarmTextView.textContainer.maximumNumberOfLines = 2
        cell.alarmTextView.attributedText = myMutableString
        cell.profilePhoto.kf_setImageWithURL(profileURL, completionHandler:{
            (image, error, cacheType, imageURL) -> () in
            cell.profilePhoto.image = cell.profilePhoto.image?.af_imageRoundedIntoCircle()
        })
        
        if isCheck == false {
            cell.contentView.backgroundColor = UIColorFromRGB(0xedf3ff)
            cell.alarmTextView.backgroundColor = UIColorFromRGB(0xedf3ff)
        }else{
            cell.contentView.backgroundColor = UIColorFromRGB(0xffffff)
            cell.alarmTextView.backgroundColor = UIColorFromRGB(0xffffff)
        }
        
        /*
        if let data = NSData(contentsOfURL: profileURL)
        {
            cell.profilePhoto.image = UIImage(data: data)?.af_imageRoundedIntoCircle()
        }
        */
        
        
        

        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41.33
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
