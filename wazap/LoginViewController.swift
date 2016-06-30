//
//  LoginViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{

    /**
     @ 뷰 로드
     */
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //페이스북 토큰이 없으면 로그인시킴
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in..")
        }
        else{
            print("logged in..")
            self.performSelector(#selector(LoginViewController.loadNextViewController), withObject: nil, afterDelay: 0)
        }
        
        //페이스북 로그인 버튼 중앙에 생성
        let loginButton = FBSDKLoginButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 - 100, y: self.view.frame.size.height / 2), size: CGSize(width: 200, height: 50)))
        /**
         @!! 페이스북 퍼미션 !!
        */
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil{
            print("login completed.")
            self.performSelector(#selector(LoginViewController.loadNextViewController), withObject: nil, afterDelay: 0)   
        }
        else
        {
            print("Error")
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loadNextViewController(){
        self.performSegueWithIdentifier("showMain", sender: self)
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
