//
//  applyViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class ApplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /**
     @ Outlet
    */
    @IBOutlet weak var tableView: UITableView!
    
    /**
     @ Variables
    */
    
    var applyList : JSON?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString as String
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/applications", parameters: ["access_token": access_token, "start_id": 0, "amount": 30]).responseJSON{
            response in
            if let responseVal = response.result.value{
                self.applyList = JSON(responseVal["data"]!!)
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTouch(sender: AnyObject) {
        fadeOut()
        self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
    }
    
    /**
     @ Table
    */
     
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.applyList!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("applyCell") as! ApplyTableViewCell
        let row = indexPath.row
        
        //cell.dueDay.text = self.applyList![row]["title"]
        cell.titleLabel.text = String(self.applyList![row]["title"])
        cell.recruitLabel.text = String(self.applyList![row]["recruitment"])
        cell.applierLabel.text = String(self.applyList![row]["appliers"])
        cell.confirmLabel.text = String(self.applyList![row]["members"])
        
        if let dayString:String = self.applyList![row]["period"].stringValue {
            //String을 NSDate로 변환
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            if let formattedDate = formatter.dateFromString(dayString){
                //앞의 자리수로 자르고 day라벨에 집어넣기
                formatter.dateFormat = "yyyy-MM-dd"
                cell.dueDayLabel.text = formatter.stringFromDate(formattedDate)
                
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
        
        cell.detailButton.tag = row as Int
        cell.detailButton.addTarget(self, action: "detailModal:", forControlEvents: .TouchUpInside)
        //appliers_id 를 어찌 넘길까

        return cell
    }
    
    
    /**
     @ FadeIn FadeOut Function
     */
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.view.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.alpha = 0.0
            }, completion: nil)
    }
    
    func detailModal(sender:UIButton){
        //상세보기 모달
        
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! ArticleDetailViewController
        let row = sender.tag
        let contests_id = self.applyList![row]["contests_id"].intValue
        let applies_id = self.applyList![row]["applies_id"].stringValue
        
        print("contest_id: \(contests_id)")
        print("applies_id: \(applies_id)")
        
        detailViewController.contests_id = contests_id
        detailViewController.applies_id = applies_id
        
        //self.applyList![row]["contests_id"].intValue 여기서 받자
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
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
