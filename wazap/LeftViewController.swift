//
//  LeftViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 21..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import SidebarOverlay
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     @ Outlet
    */
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    /**
     @ Variables
    */
    let leftMenu : [String] = ["스크랩", "신청목록", "내가 쓴 글 목록"]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftMenu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("leftCell", forIndexPath: indexPath) as! LeftTableViewCell
        
        let row = indexPath.row
        cell.cellTitle.text = leftMenu[row]
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        //사이드바 닫고
        if let container = self.so_containerViewController {
            container.isLeftViewControllerPresented = false
        }
        
        //사이드메뉴 클릭시 메인컨트롤러 이동
        switch row{
        case 0:
            self.so_containerViewController!.topViewController = self.storyboard!.instantiateViewControllerWithIdentifier("scrapScreen")
        case 1:
            self.so_containerViewController!.topViewController = self.storyboard!.instantiateViewControllerWithIdentifier("applyScreen")
        case 2:
            self.so_containerViewController!.topViewController = self.storyboard!.instantiateViewControllerWithIdentifier("recruitScreen")
            //여기서 값을 못 넘기나?
        default:
            self.so_containerViewController!.topViewController = self.storyboard!.instantiateViewControllerWithIdentifier("mainScreen")
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(leftMenu.count)
        tableView.delegate = self
        tableView.dataSource = self
        
        //페이스북 정보 가져와서 사진을 넣는 로직
        let facebookId = FBSDKAccessToken.currentAccessToken().userID as String
        let photoUrl = "https://graph.facebook.com/\(facebookId)/picture?type=large"
        
        if let url = NSURL(string: photoUrl), data = NSData(contentsOfURL: url)
        {
            profilePhoto.image = UIImage(data: data)
        }
        
        //사용자 정보중 이름을 가져옴
        Alamofire.request(.GET, "http://come.n.get.us.to/users/\(facebookId)", parameters: nil).responseJSON{
            response in
            if let JSON = response.result.value{
                let username = JSON["data"]!![0]["username"]! as! String
                self.nameLabel.text = username
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "myProfileSegue"){
            let destinationController = segue.destinationViewController as! MyProfileViewController

            destinationController.facebookId = FBSDKAccessToken.currentAccessToken().userID!
            
            print(destinationController.facebookId)
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
