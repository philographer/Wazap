//
//  ViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 19..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import SidebarOverlay
import FontAwesome
import Alamofire
import FBSDKLoginKit


class ViewController : SOContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var userNumber : String?
        var userEmail : String?
        var profilePicture : String?
        var userName : String?
        
        
        
        
        
        
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,id,picture"], HTTPMethod: "GET")
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil)
            {
                //print(result)
                let datas = result as! [String: AnyObject]
                userNumber = datas["id"] as? String
                userEmail = datas["email"] as? String
                userName = datas["name"] as? String
                profilePicture = datas["picture"]!["data"]!!["url"] as? String
                
                print(userName!)
                print(userEmail!)
                print(userNumber!)
                print(profilePicture!)
                
                Alamofire.request(.POST, "http://come.n.get.us.to/facebook_oauth/users", parameters:["user_id" : userNumber!, "access_token" : FBSDKAccessToken.currentAccessToken(), "username":userName!, "profile_image":profilePicture!, "thumbnail_image":profilePicture!]).responseJSON{
                    response in
                    if let JSON = response.result.value{
                        print("JSON: \(JSON)")
                        let msg = JSON["msg"]
                        print(msg)
                    }
                }
            }
            else
            {
                print("error \(error)")
            }
        })
        
        
        
        

        

        
        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        self.leftViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftScreen")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

