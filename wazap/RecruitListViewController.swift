//
//  RecruitListViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import SwiftyJSON

class RecruitListViewController: AEAccordionTableViewController { //변경전 UIViewController, UITableViewDelegate, UITableViewDataSource
    
    
    @IBOutlet var myTableView: UITableView!
    var recruitList:JSON = JSON.null
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    
    //@IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "RecruitTableViewCell"
    private let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.expandFirstCell()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as? String
        
        let writer_id:String = FBSDKAccessToken.currentAccessToken().userID
        
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/list/\(writer_id)", headers: header).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                self.recruitList = json["data"]
                print(self.recruitList)
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Helpers
    
    func registerCell() {
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: cellIdentifier)
        print("registered")
    }
    
    func expandFirstCell() {
        let firstCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        expandedIndexPaths.append(firstCellIndexPath)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.recruitList.count)
        return self.recruitList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecruitTableViewCell
        
        let row = indexPath.row
        cell.headerView.titleLabel.text = self.recruitList[row]["title"].stringValue
        cell.headerView.recruitLabel.text = self.recruitList[row]["recruitment"].stringValue
        cell.headerView.applierLabel.text = self.recruitList[row]["appliers"].stringValue
        cell.headerView.confirmLabel.text = self.recruitList[row]["members"].stringValue
        
        if let dayString:String = self.recruitList[row]["period"].stringValue{
            //String을 NSDate로 변환
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            if let formattedDate = formatter.dateFromString(dayString){
                //앞의 자리수로 자르고 day라벨에 집어넣기
                formatter.dateFormat = "yyyy-MM-dd"
                cell.headerView.dueDayLabel.text = formatter.stringFromDate(formattedDate)
                
                //D-day 표시
                let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                if (toDate > 0){
                    cell.headerView.dueDayLabel.text = "D-" + String(Int(toDate))
                }
                else{
                    cell.headerView.dueDayLabel.text = "마감"
                }
                
            }
        }
        
        cell.headerView.detailButton.tag = self.recruitList[row]["contests_id"].intValue
        cell.headerView.detailButton.addTarget(self, action: "detailModal:", forControlEvents: .TouchUpInside)
        

        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 200.0 : 50.0
    }
    
    @IBAction func backButtonTouch(sender: AnyObject) {
        let mainController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.so_containerViewController!.topViewController = mainController
        }
    }
    
    func detailModal(sender:UIButton){
        //상세보기 모달
        
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! ArticleDetailViewController
        detailViewController.contests_id = sender.tag
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
    ///////////////////////////////여기서 나눔 //////////////
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let writer_id:String = FBSDKAccessToken.currentAccessToken().userID
        let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString
        
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/list/\(writer_id)", parameters: ["access_token": access_token]).responseJSON{
            response in
            if let responseVal = response.result.value{
                self.recruitList = JSON(responseVal["data"]!!)
                //print(self.recruitList!
                self.tableView.dataSource = self
                self.tableView.delegate = self
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
        return self.recruitList!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recruitCell", forIndexPath: indexPath) as! RecruitTableViewCell
        let row = indexPath.row
        cell.titleLabel.text = self.recruitList![row]["title"].stringValue
        cell.recruitLabel.text = self.recruitList![row]["recruitment"].stringValue
        cell.applierLabel.text = self.recruitList![row]["appliers"].stringValue
        cell.confirmLabel.text = self.recruitList![row]["members"].stringValue
        
        if let dayString:String = self.recruitList![row]["period"].stringValue{
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
        
        cell.detailButton.tag = self.recruitList![row]["contests_id"].intValue
        cell.detailButton.addTarget(self, action: "detailModal:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    
    
    /**
     @ BackButton Action
     */
    @IBAction func backButtonTouch(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        }
    }
    
    func detailModal(sender:UIButton){
        //상세보기 모달
        
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! ArticleDetailViewController
        detailViewController.contests_id = sender.tag
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
    
    
    */

}
