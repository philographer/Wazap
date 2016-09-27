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

class WriteViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate, ChildNameDelegate{
    /**
     @ Outlet field, button
    */
    
    @IBOutlet weak var contentTitleLabel: UITextField!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var organizerLabel: UITextField!
    @IBOutlet weak var introTextView: UITextView!
    
    @IBOutlet weak var recruitLabel: UITextField!
    @IBOutlet weak var dateTextLabel: UITextField!
    
    @IBOutlet weak var adIdeaMarketingButton: CheckBox!
    @IBOutlet weak var designButton: CheckBox!
    @IBOutlet weak var picUccButton: CheckBox!
    @IBOutlet weak var foreignButton: CheckBox!
    @IBOutlet weak var gameSoftwareButton: CheckBox!
    @IBOutlet weak var etcButton: CheckBox!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var positionLabel: UITextField!
    
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    /**
     @ Variables
    */
    
    var pickerDataSource = ["2명", "3명", "4명", "5명", "6명", "7명", "8명", "9명", "10명", "11명", "12명"]
    var itemAtDefaultPosition: String?
    var recruitValue : Int = 2 //Default 0
    var periodDate : String = ""
    
    var isModify: Bool = false //modify인지 수정인지 검사
    var contest_id: Int?
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    //날짜 선택
    var datePicker:UIDatePicker!
    var recruitPicker:UIPickerView!
    let customView:UIView = UIView (frame: CGRectMake(0, 100, UIScreen.mainScreen().bounds.width, 160)) //모집기간 설정
    let customView2:UIView = UIView (frame: CGRectMake(0, 100, UIScreen.mainScreen().bounds.width, 160)) //모집인원 설정
    
    
    /**
     @ Variables
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        print(FBSDKAccessToken.currentAccessToken().tokenString)
        
        var titleView : UIImageView
        // set the dimensions you want here
        titleView = UIImageView(frame:CGRectMake(0, 0, 50, 50))
        // Set how do you want to maintain the aspect
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "detail_title_banner-4")
        self.navigationBar.topItem?.titleView = titleView
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        
        
        //로케이션에 탭 추가
        let locationTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationAction(_:)))
        self.locationLabel.addGestureRecognizer(locationTap)
        
        
        
        adIdeaMarketingButton.setImage("category_idea_icon", unchecked: "disable_category_idea_icon")
        designButton.setImage("category_design_icon", unchecked: "disable_category_design_icon")
        picUccButton.setImage("category_photo_icon", unchecked: "disable_category_photo_icon")
        gameSoftwareButton.setImage("category_game_icon", unchecked: "disable_category_game_icon")
        foreignButton.setImage("category_global_icon", unchecked: "disable_category_global_icon")
        etcButton.setImage("category_etc_icon", unchecked: "disable_category_etc_icon")
        
        
        
        
        
        
        
        
        
        
        //사진을가져와서 집어넣음
        /*
        let facebookId = FBSDKAccessToken.currentAccessToken().userID as String
        let photoUrl = "https://graph.facebook.com/\(facebookId)/picture?type=large"
        
        if let url = NSURL(string: photoUrl), data = NSData(contentsOfURL: url)
        {
            profilePhoto.image = UIImage(data: data)
        }
        */
    
        
        
        customView.tag = 1005
        datePicker = UIDatePicker(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 160))
        datePicker.locale = NSLocale(localeIdentifier: "ko_KR")
        datePicker.datePickerMode = .Date
        customView.addSubview(datePicker)
        dateTextLabel.inputView = customView
        let dateDoneButton:UIButton = UIButton (frame: CGRectMake(100, 100, 100, 44))
        dateDoneButton.setTitle("선택하기", forState: UIControlState.Normal)
        dateDoneButton.addTarget(self, action: #selector(WriteViewController.datePickerSelected), forControlEvents: UIControlEvents.TouchUpInside)
        dateDoneButton.backgroundColor = UIColor.grayColor()
        dateTextLabel.inputAccessoryView = dateDoneButton
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WriteViewController.dismissSelector))
        view.addGestureRecognizer(tap)
        
        
        recruitPicker = UIPickerView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 160))
        let recruitDoneButton:UIButton = UIButton (frame: CGRectMake(100, 100, 100, 44))
        recruitDoneButton.setTitle("선택하기", forState: UIControlState.Normal)
        recruitDoneButton.addTarget(self, action: #selector(WriteViewController.recruitPickerSelected), forControlEvents: UIControlEvents.TouchUpInside)
        recruitDoneButton.backgroundColor = UIColor.grayColor()

        recruitPicker.dataSource = self
        recruitPicker.delegate = self
        customView2.addSubview(recruitPicker)
        recruitLabel.inputView = customView2
        recruitLabel.inputAccessoryView = recruitDoneButton

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
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
    
    //childDelegate
    func dataChanged(str: String) {
        locationLabel.text = str
    }
    
    //셀렉터 숨김
    func dismissSelector(){
        dateTextLabel.endEditing(true)
        recruitLabel.endEditing(true)
    }
    
    
    func recruitPickerSelected() {
        //텍스트박스에 값 집어넣음
        recruitLabel.text = String(self.recruitValue) + "명"
        recruitLabel.endEditing(true)
        
    }
    
    //날짜 선택
    func datePickerSelected() {
        let deFormatter = NSDateFormatter()
        deFormatter.dateFormat = "yyyy-MM-dd"
        periodDate = deFormatter.stringFromDate(datePicker.date)
        dateTextLabel.text = periodDate
        dateTextLabel.endEditing(true)
        print(periodDate)
    }
    
    /**
     @ Picker Action
     */
    @IBAction func backButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     @ Category Action Todo: 카테고리 체크박스 하드코딩 ㅠ_ㅠ
     */
    @IBAction func adIdeaMarketingAction(sender: AnyObject) {
        if adIdeaMarketingButton.isChecked {
            adIdeaMarketingButton.uncheck()
        }else{
            adIdeaMarketingButton.check()
        }
    }
    
    @IBAction func designAction(sender: AnyObject) {
        if designButton.isChecked {
            designButton.uncheck()
        }else{
            designButton.check()
        }
    }
    @IBAction func picUccAction(sender: AnyObject) {
        if picUccButton.isChecked{
            picUccButton.uncheck()
        }else{
            picUccButton.check()
        }
    }
    
    @IBAction func foreignAction(sender: AnyObject) {
        if foreignButton.isChecked{
            foreignButton.uncheck()
        }else{
            foreignButton.check()
        }
    }
    @IBAction func gameSoftwareAction(sender: AnyObject) {
        if gameSoftwareButton.isChecked{
            gameSoftwareButton.uncheck()
        }else{
            gameSoftwareButton.check()
        }
    }
    @IBAction func etcAction(sender: AnyObject) {
        if etcButton.isChecked{
            etcButton.uncheck()
        }else{
           etcButton.check()
        }
    }
    
    func locationAction(sender: UITapGestureRecognizer) {
        let modalViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LocationViewController") as! LocationViewController
        
        modalViewController.delegate = self
        self.presentViewController(modalViewController, animated: false, completion: nil)
    }
    
    
    /**
     @ 만들기 버튼 Action 클릭
     */
    @IBAction func createButtonTouch(sender: AnyObject) {
        
        print("제출버튼 클릭")
        
        var categories: [String] = []
        
        if(self.adIdeaMarketingButton.isChecked){
            categories.append("광고/아이디어/마케팅")
        }
        if(self.designButton.isChecked){
            categories.append("디자인")
        }
        if(self.picUccButton.isChecked){
            categories.append("사진/UCC")
        }
        if(self.gameSoftwareButton.isChecked){
            categories.append("게임/소프트웨어")
        }
        if(self.foreignButton.isChecked){
            categories.append("해외")
        }
        if(self.etcButton.isChecked){
            categories.append("기타")
        }
        
        
        
        let content_title = contentTitleLabel.text! as String
        let title = titleLabel.text! as String
        let recruitment = recruitValue as Int
        let hosts = organizerLabel.text! as String
        let period = periodDate as String
        let cover = introTextView.text! as String
        let positions = positionLabel.text!
        let location = locationLabel.text!
        
        //Validation 검증
        
        
        
        
        let validation = self.validation(content_title, title: title, categories: categories, recruitment: recruitment, hosts: hosts, period: period, cover: cover, positions: positions, location: location)
        
        //발리데이션 통과 못 하면 끝
        guard validation else{
            return
        }
        
        if(!self.isModify){ //글작성
            Alamofire.request(.POST, "http://come.n.get.us.to/contests",headers: header ,parameters: [
                "title": title,
                "recruitment": recruitment,
                "hosts": hosts,
                "categories": categories,
                "period": period,
                "cover": cover,
                "cont_locate": location,
                "cont_title": content_title,
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
        else{
            Alamofire.request(.PUT, "http://come.n.get.us.to/contests/\(contest_id!)", headers: header, parameters: [
                "title": title,
                "recruitment": recruitment,
                "hosts": hosts,
                "categories": categories,
                "period": period,
                "cover": cover,
                "cont_locate": location,
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
    
    func validation(cont_title: String, title: String, categories: [String], recruitment: Int, hosts: String, period: String, cover: String, positions: String, location: String) -> Bool{
        if(cont_title == ""){
            alertMessage("제목을 작성해 주세요.")
            return false
        }else if(title == ""){
            alertMessage("공모전 명칭을 작성해 주세요.")
            return false
        }else if(recruitment == 0){
            alertMessage("모집 인원을 선택해 주세요")
            return false
        }else if(hosts == ""){
            alertMessage("모집 주최를 입력해 주세요")
            return false
        }else if(period == ""){
            alertMessage("날짜를 입력해 주세요")
            return false
        }else if(cover == ""){
            alertMessage("상세 소개를 입력해 주세요")
            return false
        }else if(positions == ""){
            alertMessage("모집 직군를 입력해 주세요")
            return false
        }else if(categories.count > 2){
            alertMessage("카테고리는 2개 이하만 가능합니다.")
            return false
        }else if(categories.count == 0){
            alertMessage("카테고리는 하나 이상 선택해야 합니다.")
            return false
        }else if(location == ""){
            alertMessage("지역을 선택해 주세요")
            return false
        }
        else{
            //Date 변환
            let deFormatter = NSDateFormatter()
            deFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = deFormatter.dateFromString(period)
            let toDate = floor(formattedDate!.timeIntervalSinceNow / 3600 / 24)
            if (toDate <= 0){
                alertMessage("모집 마감일은 금일보다 이후가 되어야 합니다.")
                return false
            }else{
                return true
            }
        }
    }
    
    func alertMessage(msg: String){
        let alertView = UIAlertController(title: "Notification", message: msg, preferredStyle: .Alert)
        let cancle = UIAlertAction(title: "확인", style: .Default, handler: {
            Void in
            
        })
        alertView.addAction(cancle)
        
        self.presentViewController(alertView, animated: true, completion: nil)
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
