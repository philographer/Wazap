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
        self.loadData()
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
        
        //신청버튼
        cell.applyButton.addTarget(self, action: "applyAction:", forControlEvents: .TouchUpInside)
        cell.applyButton.tag = self.scrapList![row]["contests_id"].intValue
        
        //자세히보기 버튼
        cell.detailButton.addTarget(self, action: "detailAction:", forControlEvents: .TouchUpInside)
        cell.detailButton.tag = self.scrapList![row]["contests_id"].intValue
        
        //삭제하기 버튼
        cell.deleteButton.addTarget(self, action: "deleteAction:", forControlEvents: .TouchUpInside)
        cell.deleteButton.tag = self.scrapList![row]["contests_id"].intValue


        
        
        
        
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
    
    func detailAction(sender: UIButton){
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! ArticleDetailViewController
        detailViewController.contests_id = sender.tag
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func applyAction(sender: UIButton){
        
        let contests_id:Int = sender.tag
        let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString as String
        print(contests_id)
        let alertController = UIAlertController(title: "신청하기", message: "신청하시겠습니까?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "취소", style: .Destructive, handler: nil)
        let okAction = UIAlertAction(title: "신청", style: .Default, handler: {(action)
            in
            Alamofire.request(.POST, "http://come.n.get.us.to/contests/\(contests_id)/join", parameters: ["access_token": access_token]).responseJSON{
                response in
                if let responseVal = response.result.value{
                    let alertController2 = UIAlertController(title: "신청결과", message: responseVal["msg"]!! as? String, preferredStyle: .Alert)
                    let okAction2 = UIAlertAction(title: "완료", style: .Default, handler: { (action)
                        in
                        self.tableView.reloadData()
                    })
                    alertController2.addAction(okAction2)
                    self.presentViewController(alertController2, animated: true, completion: nil)
                }
            }
            
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteAction(sender: UIButton) {
        let contests_id:Int = sender.tag
        let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString as String
        Alamofire.request(.DELETE, "http://come.n.get.us.to/clips/\(contests_id)", parameters: ["access_token": access_token]).responseJSON{
            response in
            if let responseVal = response.result.value{
                let responseJSON = JSON(responseVal)
        
                let msg:String = responseJSON["msg"].stringValue
                let alertController = UIAlertController(title: "찜삭제", message: msg, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: {
                (action) in
                    self.loadData()
                    self.tableView.reloadData()
                })
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
        
        
    }
    
    func loadData(){
        let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString as String
        let amount:Int = 20
        Alamofire.request(.GET, "http://come.n.get.us.to/clips", parameters: ["access_token": access_token, "amount": amount]).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                self.scrapList = json["data"]
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
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
