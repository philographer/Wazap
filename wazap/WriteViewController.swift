//
//  WriteViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

class WriteViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var organizerLabel: UITextField!
    @IBOutlet weak var recruitNumberPicker: UIPickerView!
    @IBOutlet weak var dayPicker: UIDatePicker!
    @IBOutlet weak var introTextView: UITextView!
    
    var pickerDataSource = ["2명", "3명", "4명", "5명", "6명", "7명", "8명", "9명", "10명", "11명", "12명"]
    var recruitValue : Int?
    var periodDate : String = ""
    
    /**
    @Picker, Button
    */
    @IBAction func backButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func datePickerChanged(sender: AnyObject) {
        let deFormatter = NSDateFormatter()
        deFormatter.dateFormat = "yyyy-MM-dd"
        periodDate = deFormatter.stringFromDate(sender.date!!)
        print(periodDate)
    }
    
    //만들기 버튼 클릭
    @IBAction func createButtonTouch(sender: AnyObject) {

        let access_token = FBSDKAccessToken.currentAccessToken().tokenString as String
        let title = titleLabel.text! as String
        let recruitment = recruitValue! as Int
        let hosts = organizerLabel.text! as String
        let categories = "{dev:true, design:false}"
        let period = periodDate as String
        let cover = introTextView.text! as String
        let positions = "개발자/디자인/기획자"
        
        
        Alamofire.request(.POST, "http://come.n.get.us.to/contests" , parameters: ["access_token":access_token, "title":title, "recruitment": recruitment, "hosts": hosts, "categories":categories, "period":period, "cover":cover, "positions":positions]).responseJSON{
            response in
            if let JSON =  response.result.value{
                let msg = JSON["msg"]
                print(msg)
                
            }
        }
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row{
        case 0,1,2,3,4,5,6,7,8,9,10:
            print(String(row+2) + "명")
            recruitValue = row+2
        default:
            break
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
