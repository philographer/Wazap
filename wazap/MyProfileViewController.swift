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

class MyProfileViewController: UIViewController {
    
    /**
     @ Outlet
    */
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kakaoLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var locateLabel: UILabel!
    @IBOutlet weak var introduceLabel: UITextView!
    @IBOutlet weak var expLabel: UITextView!
    @IBOutlet weak var activityIND: UIActivityIndicatorView!
    
    /**
     @ Variables
    */
    var overlay : UIView?
    
    /**
     @ 뷰 로드
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        let facebookId = FBSDKAccessToken.currentAccessToken().userID
        //사진정보 가져와서 넣음
        let photoUrl = "https://graph.facebook.com/\(facebookId)/picture?type=large"
        
        if let url = NSURL(string: photoUrl), data = NSData(contentsOfURL: url)
        {
            self.profilePhoto.image = UIImage(data: data)
        }
        
        //사용자 정보 집어넣음
        
        Alamofire.request(.GET, "http://come.n.get.us.to/users/\(facebookId)", parameters: nil).responseJSON{
            response in
            if let JSON = response.result.value{
                
                let age = JSON["data"]!![0]["age"] as! NSNumber
                let ageString : String = "\(age)"
                self.ageLabel.text = ageString
                self.expLabel.text = JSON["data"]!![0]["exp"] as? String
                self.introduceLabel.text = JSON["data"]!![0]["introduce"] as? String
                self.kakaoLabel.text = JSON["data"]!![0]["kakao_id"] as? String
                self.locateLabel.text = JSON["data"]!![0]["locate"] as? String
                self.majorLabel.text = JSON["data"]!![0]["major"] as? String
                self.schoolLabel.text = JSON["data"]!![0]["school"] as? String
                self.nameLabel.text = JSON["data"]!![0]["username"] as? String

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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


