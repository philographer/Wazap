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

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var kakaoTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var skillTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var introduceLabel: UITextView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var innerView2: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var innerViewConstraint: NSLayoutConstraint!
    
    var profileImage : UIImage?
    var name : String?
    var kakao : String?
    var school : String?
    var major : String?
    var locate : String?
    var skill : String?
    var introduce : String?
    
    
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    
    /**
     @ 뷰 로드
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.name)
        
        self.profilePhoto.image = self.profileImage
        self.nameTextField.text = self.name
        self.kakaoTextField.text = self.kakao
        self.schoolTextField.text = self.school
        self.majorTextField.text = self.major
        self.skillTextField.text = self.skill
        self.locationTextField.text = self.locate
        self.introduceLabel.text = self.introduce
        
    }
    
    override func viewDidLayoutSubviews() {
        //let screenHeight = UIScreen.mainScreen().bounds.height
        //let innerView2Ypos = self.innerView2.frame.origin.y
        //let navHeight = self.navigationBar.frame.height
        self.innerViewConstraint.constant -= 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     @ 뒤로가기 버튼
    */
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     @ 저장하기 버튼
    */
    @IBAction func saveButtonTouch(sender: AnyObject) {
        
        let param =  [
            "kakao_id" : kakaoTextField.text! as String,
            "username" : nameTextField.text! as String,
            "school" : schoolTextField.text! as String,
            "skill" : skillTextField.text! as String,
            "major" : majorTextField.text! as String,
            "locate" : locationTextField.text! as String,
            "introduce" : introduceLabel.text! as String,
            "exp" : "경험" as String
            ] as [String:AnyObject]
 
            Alamofire.request(.POST, "http://come.n.get.us.to/users/reg", headers: header,parameters: param).responseJSON{
            response in
            if let JSON = response.result.value{
                print(JSON["msg"])
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
