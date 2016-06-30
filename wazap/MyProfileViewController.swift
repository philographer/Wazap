//
//  MyProfileViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import SwiftyJSON

class MyProfileViewController: UIViewController {
    
    /**
     @ Outlet
    */
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kakaoLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var locateLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var introduceLabel: UITextView!
    @IBOutlet weak var expLabel: UITextView!
    @IBOutlet weak var activityIND: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var profileNavigationBar: UINavigationItem!
    @IBOutlet weak var profileEditButton: UIBarButtonItem!
    
    @IBOutlet weak var innerView2: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var innerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    /**
     @ Variables
    */
    var overlay : UIView?
    var facebookId:String?
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    
    
    /**
     @ 뷰 로드
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if facebookId != FBSDKAccessToken.currentAccessToken().userID {
            self.profileEditButton.tintColor = UIColor.clearColor()
            self.profileEditButton.enabled = false
        }else{
            self.profileEditButton.tintColor = nil
            self.profileEditButton.enabled = true
        }
    }
    /**
      @ Todo: Scroll View의 Constraint문제
     */
    override func viewDidLayoutSubviews() {
        //let screenHeight = UIScreen.mainScreen().bounds.height
        //let innerView2Ypos = self.innerView2.frame.origin.y
        //let navHeight = self.navigationBar.frame.height
        //self.innerViewConstraint.constant = screenHeight - innerView2Ypos - navHeight - 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     @ 뷰 나타남
    */
    override func viewWillAppear(animated: Bool) {
        
        self.activityIND.hidden = false
        activityIND.startAnimating()
        
        
        //로그인한 사람이 현재 보여주는 사람이 아니면 Back버튼 숨김
        if (FBSDKAccessToken.currentAccessToken().userID != facebookId){
            //self.backButton.enabled = false
            //self.backButton.title = ""
        }
        
        //사진정보 가져와서 넣음
        let photoUrl = "https://graph.facebook.com/\(facebookId!)/picture?type=large"
        
        
        self.profilePhoto.kf_setImageWithURL(NSURL(string: photoUrl)!, completionHandler:{
            (image, error, cacheType, imageURL) -> () in
            self.profilePhoto.image = self.profilePhoto.image?.af_imageRoundedIntoCircle()
        })
    
        
        
        
        //사용자 정보 집어넣음
        Alamofire.request(.GET, "http://come.n.get.us.to/users/\(facebookId!)", parameters: nil).responseJSON{
            response in
            if let responseVal = response.result.value{
                
                let json = JSON(responseVal)
                self.skillLabel.text = json["data"][0]["skill"].stringValue
                self.expLabel.text = json["data"][0]["exp"].stringValue
                //self.introduceLabel.text = json["data"][0]["introduce"].stringValue
                self.kakaoLabel.text = json["data"][0]["kakao_id"].stringValue
                self.locateLabel.text = json["data"][0]["locate"].stringValue
                self.majorLabel.text = json["data"][0]["major"].stringValue
                self.schoolLabel.text = json["data"][0]["school"].stringValue
                self.nameLabel.text = json["data"][0]["username"].stringValue
                
            }
        }
    }
    
    /**
     @ 뷰 나타난 뒤
    */
    override func viewDidAppear(animated: Bool) {
        self.activityIND.stopAnimating()
        self.activityIND.hidden = true
    }
    
    /**
     @ 모달 닫기 Action
    */
    @IBAction func closeModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func closeView(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func settingAction(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowModificationProfile", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        if segue.identifier == "ShowModificationProfile"{
            print("segue")
            let vc = segue.destinationViewController as! MyProfileModificationViewController
            vc.profileImage = self.profilePhoto.image!
            vc.name = self.nameLabel.text!
            vc.kakao = self.kakaoLabel.text!
            vc.school = self.schoolLabel.text!
            vc.major = self.majorLabel.text!
            vc.locate = self.locateLabel.text!
            vc.skill = self.skillLabel.text!
            vc.introduce = self.introduceLabel.text!
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


