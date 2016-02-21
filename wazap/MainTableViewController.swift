//
//  MainTableViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 19..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import SwiftyJSON


class MainTableViewController: UITableViewController {
    
    
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    @IBAction func showMeMyMenu () {
        if let container = self.so_containerViewController {
            container.isLeftViewControllerPresented = true
        }
    }
    
    let dayArr:[String] = ["3/5","3/4","3/8","3/10"] // 마감일 배열
    let articleTitleArr:[String] = ["티스토리 공모전 함께해요", "매일유업 공모전 함께해요", "선라이즈 공모전 함께해요", "한전 공모전 함께해요"] //모집명 배열
    let dueDayArr:[String] = ["D-24", "D-12", "D-13", "D-24"] // D-day 배열
    let dueTimeArr:[String] = ["3분전", "4분전", "5분전", "6분전"] //몇분전 배열
    let organizerArr:[String] = ["다음", "매일유업", "선토리", "한국전력"] //명칭 및 주관 배열
    let hostNameArr:[String] = ["오이담", "홍길동", "김갑수", "이시형"] //명칭 및 주관 배열
    let categoryArr:[String] = ["디자인", "개발", "기획", "디자인"] //카테고리 배열
    let tagListArr:[String] = ["#디자이너 #개발자", "D-12", "D-13", "D-24"] //팀원 리스트 배열
    let introArr:[String] = ["Blah Blah Blah Blah Blah Blah", "Blah Blah Blah Blah Blah Blah", "Blah Blah Blah Blah Blah Blah", "Blah Blah Blah Blah Blah Blah"] //방 소개
    let recruitNumberArr:[String] = ["12", "6", "8", "10"] //모집예정 인원
    let nowNumberArr:[String] = ["3", "2", "1", "4"] //현재 신청중인 인원
    let nameListArr:[String] = ["최소담,홍길동,김미연", "이호형, 이상형", "오이담", "홍길동2,홍길동3,홍길동4,홍길동5"] //현재 참가자


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 5 * 4, y: self.view.frame.size.height / 5 * 4), size: CGSize(width: 50, height: 50)))
        button.backgroundColor = UIColor.whiteColor()
        button.setImage(UIImage(named: "pen.png"), forState: UIControlState.Normal)
        button.addTarget(self, action: "writeButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func writeButton(sender:UIButton){
        let writeController = self.storyboard?.instantiateViewControllerWithIdentifier("writeViewController")
        
        self.presentViewController(writeController!, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dayArr.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =
        self.tableView.dequeueReusableCellWithIdentifier(
            "MainTableCell", forIndexPath: indexPath)
            as! MainTableViewCell
        
        
        let row = indexPath.row
        
        cell.articleTitle.text = articleTitleArr[row]
        cell.day.text = dayArr[row]
        cell.dueDay.text = dueDayArr[row]
        cell.dueTime.text = dueTimeArr[row]
        cell.hostName.text = hostNameArr[row]
        cell.category.text = categoryArr[row]
        cell.tagList.text = tagListArr[row]
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "ShowArticleDetail"{

            let detailViewController = segue.destinationViewController as! ArticleDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row:Int = myIndexPath!.row
            print(row)
            print(articleTitleArr[row])
            

            detailViewController.articleTitleLabelText = articleTitleArr[row] //모집명
            detailViewController.dueDayLabelText = dueDayArr[row]
            detailViewController.organizerLabelText = organizerArr[row]
            detailViewController.categoryLabelText = categoryArr[row]
            detailViewController.recruitNumberLabelText = recruitNumberArr[row]
            detailViewController.nameListLabelText = nameListArr[row]
            detailViewController.nowNumberLabelText = nowNumberArr[row]
            detailViewController.hostNameLabelText = hostNameArr[row]
            detailViewController.introLabelText = introArr[row]

            
        }
    
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }

}
