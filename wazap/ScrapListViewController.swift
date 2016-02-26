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
    

    var scrapList:AnyObject? = "" //스크랩 리스트
    
    /**
     @ Outlet
    */
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let access_token:String = FBSDKAccessToken.currentAccessToken().tokenString as String
        let start_id:Int = 30
        let amount:Int = 20
        print(access_token)
        Alamofire.request(.GET, "http://come.n.get.us.to/clips", parameters: ["access_token": access_token, "start_id": start_id, "amount": amount]).responseJSON{
            response in
            print(response)
            if let JSON = response.result.value{
                print(JSON)
                self.scrapList = JSON["msg"]
                print(self.scrapList)
            }
        }
        
        // Do any additional setup after loading the view.
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
