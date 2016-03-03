//
//  MyProfileModificationViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import SwiftyJSON

class MyProfileModificationViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var kakaoField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var locateField: UITextField!
    @IBOutlet weak var introduceField: UITextView!
    @IBOutlet weak var expField: UITextView!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    /**
     @ 뷰 로드
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //페이스북 프로필, 이름정보
        let facebookId = FBSDKAccessToken.currentAccessToken().userID as String
        let photoUrl = "https://graph.facebook.com/\(facebookId)/picture?type=large"
        if let url = NSURL(string: photoUrl), data = NSData(contentsOfURL: url){
            profilePhoto.image = UIImage(data: data)
        }
        
        //내 정보 불러움
        Alamofire.request(.GET, "http://come.n.get.us.to/users/\(facebookId)", parameters: nil).responseJSON{
            response in
            print(response)
            if let JSON = response.result.value{
                print(JSON)
                
                dispatch_async(dispatch_get_main_queue(), {
                    let age = JSON["data"]!![0]["age"] as! NSNumber
                    let ageString : String = "\(age)"
                    self.nameField.text = JSON["data"]!![0]["username"] as? String
                    self.kakaoField.text = JSON["data"]!![0]["kakao_id"] as? String
                    self.schoolField.text = JSON["data"]!![0]["school"] as? String
                    self.ageField.text = ageString
                    self.majorField.text = JSON["data"]!![0]["major"] as? String
                    self.locateField.text = JSON["data"]!![0]["locate"] as? String
                    self.introduceField.text = JSON["data"]!![0]["introduce"] as? String
                    self.expField.text = JSON["data"]!![0]["exp"] as? String
                })
                
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     @ 뒤로가기 버튼
    */
    @IBAction func backButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     @ 저장하기 버튼
    */
    @IBAction func saveButtonTouch(sender: AnyObject) {
        let param =  [
            "access_token" : FBSDKAccessToken.currentAccessToken().tokenString as String,
            "kakao_id" : kakaoField.text! as String,
            "username" : nameField.text! as String,
            "school" : schoolField.text! as String,
            "age" : ageField.text! as String,
            "major" : majorField.text! as String,
            "locate" : locateField.text! as String,
            "introduce" : introduceField.text! as String,
            "exp" : expField.text! as String
            ] as [String:AnyObject]
        
        Alamofire.request(.POST, "http://come.n.get.us.to/users/reg", parameters: param).responseJSON{
            response in
            if let JSON = response.result.value{
                print(JSON["result"] as! Bool)
            }
            
        }
        
        //Alert창
        let alertController = UIAlertController(title: "저장하기", message: "성공적으로 저장했습니다.", preferredStyle: .Alert)
        //Alert창에서 OK 누르면 종료
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: {action in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(okButton)
        self.presentViewController(alertController, animated: true, completion: nil)
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
