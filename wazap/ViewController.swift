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
    /**
     @ 뷰 로드
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Facebook SDK에서 이메일, 이름, id를 요청
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,id"], HTTPMethod: "GET")
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil)
            {
                let datas = result as! [String: AnyObject]
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString as String
                let userNumber = datas["id"] as! String
                let userName = datas["name"] as! String
                let profilePicture = "http://graph.facebook.com/\(userNumber)/picture?type=large"
                
                //API 회원가입 로직
                Alamofire.request(.POST, "http://come.n.get.us.to/facebook_oauth/users", parameters:["users_id" : userNumber, "access_token" : accessToken, "username":userName, "profile_image":profilePicture, "thumbnail_image":profilePicture]).responseJSON{
                    response in
                    if let JSON1 = response.result.value{
                        let results = JSON1["result"] as! Bool
                        if(results == true){ //회원가인 & 로그인성공
                            
                            //로그인 성공했을때 회원가입 정보를 요청하고 kakao톡 아이디가 없으면 등록시킴
                            Alamofire.request(.GET, "http://come.n.get.us.to/users/\(userNumber)", parameters: nil).responseJSON{
                                response in
                                if let JSON2 = response.result.value{
                                    if(JSON2["data"]!![0]["kakao_id"]!! is NSNull){ //kakao 아이디가 없으므로 회원가입시킴
                                        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("registerScreen")
                                    }
                                    else //아니면 메인페이지로 넘어감
                                    {
                                        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
                                        self.leftViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftScreen")
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            else
            {
                print("error \(error)")
            }
        })
        

    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

