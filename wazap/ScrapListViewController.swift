//
//  ScrapListViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import SwiftyJSON

class ScrapListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var scrapList:JSON? //스크랩 리스트
    
    /**
     @ Outlet
    */
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.navigationController)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString as String
        let amount:Int = 20
        Alamofire.request(.GET, "http://come.n.get.us.to/clips", parameters: ["access_token": access_token, "amount": amount]).responseJSON{
            response in
            if let responseVal = response.result.value{
                self.scrapList = JSON(responseVal["data"]!!)
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
    
    /**
     @ Table
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scrapList!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("scrapCell", forIndexPath: indexPath) as! ScrapTableViewCell
        let row = indexPath.row
        var categoryList:[String] = [] //카테고리 리스트
        
        cell.titleLabel.text = String(self.scrapList![row]["title"])
        cell.recruitLabel.text = String(self.scrapList![row]["recruitment"])
        
        
        //카테고리 변환 로직
        let stringJSON:JSON = self.scrapList![row]["categories"]
        if let wordsInclude = stringJSON.string?.characters.dropFirst().dropLast().split(",").map(String.init){
            for words in wordsInclude{
                categoryList.append(String(words.characters.dropFirst().dropLast()))
            }
        }
        cell.categoryLabel.text = String(categoryList)
        
        //D-Day 변환 로직
        if let dayString:String = self.scrapList![row]["period"].stringValue {
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
        
        
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    /**
     @ BackButton Action
     */
    @IBAction func backButtonTouch(sender: AnyObject) {
        
        let mainController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.so_containerViewController!.topViewController = mainController
        }
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
