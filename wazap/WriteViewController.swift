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
import SwiftyJSON

class WriteViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    /**
     @ Outlet field, button
    */
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var organizerLabel: UITextField!
    @IBOutlet weak var recruitNumberPicker: UIPickerView!
    @IBOutlet weak var dayPicker: UIDatePicker!
    @IBOutlet weak var introTextView: UITextView!
    
    @IBOutlet weak var itContentButton: UIButton!
    @IBOutlet weak var marketingButton: UIButton!
    @IBOutlet weak var designButton: UIButton!
    @IBOutlet weak var literatureButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var planningButton: UIButton!
    
    /**
     @ Variables
    **/
    var category_it_contents:Bool = false
    var category_market_ad: Bool = false
    var category_design: Bool = false
    var category_literature_scenario: Bool = false
    var category_photo_video: Bool = false
    var category_planning_idea: Bool = false
    
    
    
    
    var pickerDataSource = ["2명", "3명", "4명", "5명", "6명", "7명", "8명", "9명", "10명", "11명", "12명"]
    
    
    var recruitValue : Int = 2
    var periodDate : String = ""
    
    
    /**
     @ Picker, Button
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
    
    /**
    @카테고리 체크박스
    */
    @IBAction func itContentButton(sender: AnyObject) {
        if(self.category_it_contents == true){
            self.category_it_contents = false
            self.itContentButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_it_contents = true
            self.itContentButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func marketingButton(sender: AnyObject) {
        if(self.category_market_ad == true){
            self.category_market_ad = false
            self.marketingButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_market_ad = true
            self.marketingButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func designButton(sender: AnyObject) {
        if(self.category_design == true){
            self.category_design = false
            self.designButton.tintColor = UIColor.blueColor()

        }
        else{
            self.category_design = true
            self.designButton.tintColor = UIColor.redColor()
        }
    }

    @IBAction func literatureButton(sender: AnyObject) {
        if(self.category_literature_scenario == true){
            self.category_literature_scenario = false
            self.literatureButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_literature_scenario = true
            self.literatureButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func photoButton(sender: AnyObject) {
        if(self.category_photo_video == true){
            self.category_photo_video = false
            self.photoButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_photo_video = true
            self.photoButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func planningButton(sender: AnyObject) {
        if(self.category_planning_idea == true){
            self.category_planning_idea = false
            self.planningButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_planning_idea = true
            self.planningButton.tintColor = UIColor.redColor()
        }
    }
    
    /**
    @만들기 버튼 클릭
    */
    @IBAction func createButtonTouch(sender: AnyObject) {
        
        print("제출버튼 클릭")
        
        var categories: [String] = []
        
        if(category_it_contents){
            categories.append("IT/콘텐츠")
        }
        if(category_design){
            categories.append("마케팅/광고")
        }
        if(category_literature_scenario){
            categories.append("디자인")
        }
        if(category_market_ad){
            categories.append("문학/시나리오")
        }
        if(category_photo_video){
            categories.append("사진/영상")
        }
        if(category_planning_idea){
            categories.append("기획/디자인")
        }
        

        
        let access_token = FBSDKAccessToken.currentAccessToken().tokenString as String
        let title = titleLabel.text! as String
        let recruitment = recruitValue as Int
        let hosts = organizerLabel.text! as String
        let period = periodDate as String
        let cover = introTextView.text! as String
        let positions = "개발자/디자인/기획자" as String
        
        let parameters : [String: AnyObject] = [
            "access_token": access_token,
            "categories": categories,
            "title": title,
            "recruitment": recruitment,
            "hosts": hosts,
            "period": period,
            "cover": cover,
            "positions": positions
        ]
        
        print(parameters)
        
        
        Alamofire.request(.POST, "http://come.n.get.us.to/contests", parameters: parameters).responseJSON{
            response in
            if let JSON = response.result.value{
                print(JSON["msg"])
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        /**
         @ Bool 변수 초기화
        */
        category_it_contents = false
        category_literature_scenario = false
        category_design = false
        category_market_ad = false
        category_photo_video = false
        category_planning_idea = false
        
        /**
         @ 오늘날짜, 모집인원 초기화
        */
        
        //오늘날짜 String으로 형변환
        let todayNSDate = NSDate()
        let deFormatter = NSDateFormatter()
        deFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = deFormatter.stringFromDate(todayNSDate)
        
        
        //형변환한 날짜 집어넣고 모집인원 초기화
        self.periodDate = todayString
        self.recruitValue = 2
        
        
        
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
