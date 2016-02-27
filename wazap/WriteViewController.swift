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
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var designUccButton: UIButton!
    @IBOutlet weak var itDevButton: UIButton!
    @IBOutlet weak var marketAdButton: UIButton!
    @IBOutlet weak var paperLiteratureButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    
    /**
     @ Variables
    */
    var category_design_ucc:Bool = false
    var category_paper_literature: Bool = false
    var category_it_dev: Bool = false
    var category_market_ad: Bool = false
    var category_game: Bool = false
    var category_etc: Bool = false
    
    var pickerDataSource = ["2명", "3명", "4명", "5명", "6명", "7명", "8명", "9명", "10명", "11명", "12명"]
    var itemAtDefaultPosition: String?
    var recruitValue : Int = 2 //Default 2
    var periodDate : String = ""
    
    var isModify: Bool = false //modify인지 수정인지 검사
    var contest_id: Int?
    
    /**
     @ Variables
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        //사진을가져와서 집어넣음
        let facebookId = FBSDKAccessToken.currentAccessToken().userID as String
        let photoUrl = "https://graph.facebook.com/\(facebookId)/picture?type=large"
        
        if let url = NSURL(string: photoUrl), data = NSData(contentsOfURL: url)
        {
            profilePhoto.image = UIImage(data: data)
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        /**
         @ Bool 변수 초기화
        */
        category_design_ucc = false // 디자인/UCC
        category_it_dev = false // IT/개발
        category_market_ad = false // 마케팅/광고
        category_paper_literature = false // 논문/문학
        category_game = false // 게임
        category_etc = false // ETC
        
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
    
    /**
     @ Picker Action
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
     @ Category Action Todo: 카테고리 체크박스 하드코딩 ㅠ_ㅠ
     */
    @IBAction func designUccButton(sender: AnyObject) {
        if(self.category_design_ucc == true){
            self.category_design_ucc = false
            self.designUccButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_design_ucc = true
            self.designUccButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func itDevButton(sender: AnyObject) {
        if(self.category_paper_literature == true){
            self.category_paper_literature = false
            self.itDevButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_paper_literature = true
            self.itDevButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func marketAdButton(sender: AnyObject) {
        if(self.category_it_dev == true){
            self.category_it_dev = false
            self.marketAdButton.tintColor = UIColor.blueColor()
            
        }
        else{
            self.category_it_dev = true
            self.marketAdButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func paperLiteratureButton(sender: AnyObject) {
        if(self.category_market_ad == true){
            self.category_market_ad = false
            self.paperLiteratureButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_market_ad = true
            self.paperLiteratureButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func gameButton(sender: AnyObject) {
        if(self.category_game == true){
            self.category_game = false
            self.gameButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_game = true
            self.gameButton.tintColor = UIColor.redColor()
        }
    }
    
    @IBAction func etcButton(sender: AnyObject) {
        if(self.category_etc == true){
            self.category_etc = false
            self.etcButton.tintColor = UIColor.blueColor()
        }
        else{
            self.category_etc = true
            self.etcButton.tintColor = UIColor.redColor()
        }
    }
    
    /**
     @ 만들기 버튼 Action 클릭
     */
    @IBAction func createButtonTouch(sender: AnyObject) {
        
        print("제출버튼 클릭")
        
        var categories: [String] = []
        
        if(category_design_ucc){
            categories.append("디자인/UCC")
        }
        if(category_it_dev){
            categories.append("IT/개발")
        }
        if(category_market_ad){
            categories.append("마케팅/광고")
        }
        if(category_paper_literature){
            categories.append("논문/문학")
        }
        if(category_game){
            categories.append("게임")
        }
        if(category_etc){
            categories.append("기타")
        }
        
        /*
        디자인/UCC category_design_ucc
        IT/개발 category_it_dev
        마케팅/광고 category_market_ad
        논문/문학 category_paper_literature
        게임 category_game
        ETC category_etc
        */
        
        let access_token = FBSDKAccessToken.currentAccessToken().tokenString as String
        let title = titleLabel.text! as String
        let recruitment = recruitValue as Int
        let hosts = organizerLabel.text! as String
        let period = periodDate as String
        let cover = introTextView.text! as String
        let positions = "개발자/디자인/기획자" as String
        
        let parameters : [String: AnyObject] = [
            "access_token": access_token,
            "title": title,
            "recruitment": recruitment,
            "hosts": hosts,
            "categories": categories,
            "period": period,
            "cover": cover,
            "positions": positions
        ]
        
    
        
        //print(parameters["categories"]!)
        //print(access_token)
        //print(title)
        //print(recruitment)
        //print(hosts)
        //print(period)
        //print(cover)
        //print(positions)
        
        
        
        if(!self.isModify){ //글작성
            
            //print("access_token: \(access_token)")
            //print("title: \(title)")
            //print("recruitment: \(recruitment)")
            //print("hosts: \(hosts)")
            //print("categories: \(categories)")
            //print("period: \(period)")
            //print("cover: \(cover)")
            //print("positions: \(positions)")
            
            Alamofire.request(.POST, "http://come.n.get.us.to/contests", parameters: [
                "access_token": access_token,
                "title": title,
                "recruitment": recruitment,
                "hosts": hosts,
                "categories": categories,
                "period": period,
                "cover": cover,
                "positions": positions], encoding: .JSON).responseJSON{
                    response in
                    if let JSON = response.result.value{
                        print(JSON["result"]!!)
                        let alerltController = UIAlertController(title: "작성하기", message: JSON["msg"]!! as? String, preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "ok", style: .Default, handler: {(action) in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                        alerltController.addAction(okAction)
                        self.presentViewController(alerltController, animated: true, completion: nil)
                        
                    }
            }
        }
        else{ //수정
            //print("access_token: \(access_token)")
            //print("title: \(title)")
            //print("recruitment: \(recruitment)")
            //print("hosts: \(hosts)")
            //print("categories: \(categories)")
            //print("period: \(period)")
            //print("cover: \(cover)")
            //print("positions: \(positions)")
            
            Alamofire.request(.PUT, "http://come.n.get.us.to/contests/\(contest_id!)", parameters: [
                "access_token": access_token,
                "title": title,
                "recruitment": recruitment,
                "hosts": hosts,
                "categories": categories,
                "period": period,
                "cover": cover,
                "positions": positions], encoding: .JSON).responseJSON{
                response in
                if let JSON = response.result.value{
                    let alertController = UIAlertController(title: "결과", message: JSON["msg"]!! as? String, preferredStyle: .Alert)
                    let alertOkAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(alertOkAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            
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
