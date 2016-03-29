//
//  AccordionMenuTableViewController.swift
//  AccordionTableSwift
//
//  Created by Victor Sigler on 2/4/15.
//  Copyright (c) 2015 Private. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit



class RecruitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    /// The number of elements in the data source
    var total = 0
    
    /// The data source
    var dataSource: [Parent]!
    
    /// Define wether can exist several cells expanded or not.
    let numberOfCellsExpanded: NumberOfCellExpanded = .One
    
    /// Constant to define the values for the tuple in case of not exist a cell expanded.
    let NoCellExpanded = (-1, -1)
    
    /// The index of the last cell expanded and its parent.
    var lastCellExpanded : (Int, Int)!
    var recruitList = JSON.null
    var recruitMemberList:[JSON] = []
    //하나당...
    //자식목록 
    
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let writer_id:String = FBSDKAccessToken.currentAccessToken().userID
        //print(self.header)
        //print(writer_id)
        Alamofire.request(.GET, "http://come.n.get.us.to/contests/list/\(writer_id)",parameters:["amount": 100] ,headers: header).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                self.recruitList = json["data"]
                self.recruitMemberList = [JSON](count: self.recruitList.count, repeatedValue: nil)
                for (index, subJson):(String, JSON) in self.recruitList{
                    let contests_id:String = subJson["contests_id"].stringValue
                    Alamofire.request(.GET, "http://come.n.get.us.to/contests/\(contests_id)/applies", headers: self.header).responseJSON{
                        response in
                        if let responseVal = response.result.value{
                            let json = JSON(responseVal)
                            let index_json:Int = Int(index)!
                            //print("\(contests_id) is \(json["result"].stringValue)")
                            //print("\(index_json)")
                            
                            //비동기로 받아온걸 올바른 순서로 넣을 수 ...
                            self.recruitMemberList[index_json] = json["data"]
                            if(self.recruitList.count == self.recruitMemberList.count){
                                self.tableView.dataSource = self
                                self.tableView.delegate = self
                                self.setInitialDataSource(numberOfRowParents: self.recruitList.count, numberOfRowChildPerParent: 6)
                                self.lastCellExpanded = self.NoCellExpanded
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Set the initial data for test the table view.
     
     - parameter parents: The number of parents cells
     - parameter childs:  Then maximun number of child cells per parent.
     */
    private func setInitialDataSource(numberOfRowParents parents: Int, numberOfRowChildPerParent childs: Int) {
        
        // Set the total of cells initially.
        self.total = parents
        
        let data = [Parent](count: parents, repeatedValue: Parent(state: .Collapsed, childs: [JSON](), parentData: JSON.null)) //이게 무슨 문법이여
        
        dataSource = data.enumerate().map({ (index: Int, var element: Parent) -> Parent in
            
            //!**************  원래 있던 타이틀  *****************!
            //element.title = "Item \(index)"
            let tempIndex = index
            
            element.parentData = self.recruitList[index]
            
            //여기서 자식 데이터 parsing
            // create the array for each cell
            //element.childs = (0..<random).enumerate().map {"Subitem \($0.index)"}
            element.childs = (0..<recruitMemberList[index].count).enumerate().map {(index, element) in
                
            return recruitMemberList[tempIndex][index]}
            
            return element
        })
    }
    
    /**
     Expand the cell at the index specified.
     
     - parameter index: The index of the cell to expand.
     */
    private func expandItemAtIndex(index : Int, parent: Int) {
        
        // the data of the childs for the specific parent cell.
        let currentSubItems = self.dataSource[parent].childs
        
        // update the state of the cell.
        self.dataSource[parent].state = .Expanded
        
        // position to start to insert rows.
        var insertPos = index + 1
        
        // create an array of NSIndexPath with the selected positions
        let indexPaths = (0..<currentSubItems.count).map { _ in NSIndexPath(forRow: insertPos++, inSection: 0) }
        
        // insert the new rows
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        // update the total of rows
        self.total += currentSubItems.count
    }
    
    /**
     Collapse the cell at the index specified.
     
     - parameter index: The index of the cell to collapse
     */
    private func collapseSubItemsAtIndex(index : Int, parent: Int) {
        
        var indexPaths = [NSIndexPath]()
        
        let numberOfChilds = self.dataSource[parent].childs.count
        
        // update the state of the cell.
        self.dataSource[parent].state = .Collapsed
        
        // create an array of NSIndexPath with the selected positions
        //print("index is \(index)")
        //print("numberOfChilds is \(numberOfChilds)")
        
        
        
        if(numberOfChilds != 0){
            indexPaths = (index+1...index + numberOfChilds).map { NSIndexPath(forRow: $0, inSection: 0)}
            
            // remove the expanded cells
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
            
            // update the total of rows
            self.total -= numberOfChilds
        }
    }
    
    /**
     Update the cells to expanded to collapsed state in case of allow severals cells expanded.
     
     - parameter parent: The parent of the cell
     - parameter index:  The index of the cell.
     */
    private func updateCells(parent: Int, index: Int) {
        
        switch (self.dataSource[parent].state) {
            
        case .Expanded:
            self.collapseSubItemsAtIndex(index, parent: parent)
            self.lastCellExpanded = NoCellExpanded
            
        case .Collapsed:
            switch (numberOfCellsExpanded) {
            case .One:
                // exist one cell expanded previously
                if self.lastCellExpanded != NoCellExpanded {
                    
                    let (indexOfCellExpanded, parentOfCellExpanded) = self.lastCellExpanded
                    
                    self.collapseSubItemsAtIndex(indexOfCellExpanded, parent: parentOfCellExpanded)
                    
                    // cell tapped is below of previously expanded, then we need to update the index to expand.
                    if parent > parentOfCellExpanded {
                        let newIndex = index - self.dataSource[parentOfCellExpanded].childs.count
                        self.expandItemAtIndex(newIndex, parent: parent)
                        self.lastCellExpanded = (newIndex, parent)
                    }
                    else {
                        self.expandItemAtIndex(index, parent: parent)
                        self.lastCellExpanded = (index, parent)
                    }
                }
                else {
                    self.expandItemAtIndex(index, parent: parent)
                    self.lastCellExpanded = (index, parent)
                }
            case .Several:
                self.expandItemAtIndex(index, parent: parent)
            }
        }
    }
    
    /**
     Find the parent position in the initial list, if the cell is parent and the actual position in the actual list.
     
     - parameter index: The index of the cell
     
     - returns: A tuple with the parent position, if it's a parent cell and the actual position righ now.
     */
    private func findParent(index : Int) -> (parent: Int, isParentCell: Bool, actualPosition: Int) {
        
        var position = 0, parent = 0
        guard position < index else { return (parent, true, parent) }
        
        var item = self.dataSource[parent]
        
        repeat {
            
            switch (item.state) {
            case .Expanded:
                position += item.childs.count + 1
            case .Collapsed:
                position += 1
            }
            
            parent += 1
            
            // if is not outside of dataSource boundaries
            if parent < self.dataSource.count {
                item = self.dataSource[parent]
            }
            
        } while (position < index)
        
        // if it's a parent cell the indexes are equal.
        if position == index {
            return (parent, position == index, position)
        }
        
        item = self.dataSource[parent - 1]
        return (parent - 1, position == index, position - item.childs.count - 1)
    }
}

extension RecruitViewController {
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let (parent, isParentCell, actualPosition) = self.findParent(indexPath.row)
        
        if !isParentCell { //자식셀
            let cell = tableView.dequeueReusableCellWithIdentifier("ChildCell", forIndexPath: indexPath) as! childCell

            //is_check
            //profile_img
            //postdate
            //app_users_id
            //applies_id
            //username
            
            
            
            //사진 집어넣음
            let photoUrl = self.dataSource[parent].childs[indexPath.row - actualPosition - 1]["profile_img"].stringValue
            if let url = NSURL(string: photoUrl), data = NSData(contentsOfURL: url)
            {
                cell.profileImage.image = UIImage(data: data)
            }
            
            
            let users_id = self.dataSource[parent].childs[indexPath.row - actualPosition - 1]["app_users_id"].intValue
            let applies_id = self.dataSource[parent].childs[indexPath.row - actualPosition - 1]["applies_id"].intValue
            let contests_id = self.dataSource[parent].parentData["contests_id"].intValue
            let is_check = self.dataSource[parent].childs[indexPath.row - actualPosition - 1]["is_check"].boolValue
            print(is_check)
            
            //print("users_id: \(users_id)")
            //print("contests_id: \(contests_id)")
            
            cell.nameLabel.text = self.dataSource[parent].childs[indexPath.row - actualPosition - 1]["username"].stringValue //이름 집어넣음
            cell.detailButton.tag = users_id
            if(is_check)
            {
                cell.acceptButton.setTitle("수락됨", forState: .Normal)
            }
            cell.detailButton.addTarget(self, action: #selector(self.detailProfile(_:)), forControlEvents: .TouchUpInside)
            
            
            ///contests/:contest_id/:applies_id => 수락버튼
            cell.acceptButton.contests_id = contests_id
            cell.acceptButton.applies_id = applies_id
            cell.acceptButton.addTarget(self, action: #selector(self.acceptAction(_:)), forControlEvents: .TouchUpInside)
            
            
            
            
            //print(self.dataSource[parent].childs[indexPath.row - actualPosition - 1])
            /*
                cell.textLabel!.text = self.dataSource[parent].childs[indexPath.row - actualPosition - 1
            ]
             */
            return cell
            
        }
        else { //부모셀
            let cell = tableView.dequeueReusableCellWithIdentifier("ParentCell", forIndexPath: indexPath) as! parentCell
            let contests_id = self.dataSource[parent].parentData["contests_id"].intValue
            
            
            cell.contestTitle.text = self.dataSource[parent].parentData["cont_title"].stringValue
            cell.recruitLabel.text = self.dataSource[parent].parentData["recruitment"].stringValue
            cell.applierLabel.text = self.dataSource[parent].parentData["appliers"].stringValue
            cell.confirmLabel.text = self.dataSource[parent].parentData["members"].stringValue
            cell.detailButton.tag = parent
            cell.detailButton.addTarget(self, action: #selector(self.detailContests(_:)), forControlEvents: .TouchUpInside)
        
            //cell.contestTitle = self.dataSource[parent]
            /*
            cell.textLabel!.text = self.dataSource[parent].title
            */
            return cell
        }
    }

    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let (parent, isParentCell, actualPosition) = self.findParent(indexPath.row)
        
        guard isParentCell else {
            NSLog("A child was tapped!!!")
            
            // The value of the child is indexPath.row - actualPosition - 1
            NSLog("The value of the child is \(self.dataSource[parent].childs[indexPath.row - actualPosition - 1])")
            
            return
        }
        
        self.tableView.beginUpdates()
        self.updateCells(parent, index: indexPath.row)
        self.tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return !self.findParent(indexPath.row).isParentCell ? 50.0 : 100.0
    }
    
    //함수들
    
    @IBAction func backButtonTouch(sender: AnyObject) {
        self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
    }
    
    func detailProfile(sender: AnyObject){
        
        let profileController = self.storyboard?.instantiateViewControllerWithIdentifier("profileViewController") as! MyProfileViewController
        profileController.facebookId = String(sender.tag)
        print(profileController.facebookId)
        self.navigationController?.pushViewController(profileController, animated: true)
        
    }
    
    func acceptAction(sender: AcceptButton){
        let contests_id:Int = sender.contests_id!
        let applies_id:Int = sender.applies_id!
        
        
        
        Alamofire.request(.POST, "http://come.n.get.us.to/contests/\(contests_id)/\(applies_id)", parameters: [:], encoding: .JSON, headers: header).responseJSON{
            response in
            if let responseVal = response.result.value{
                let json = JSON(responseVal)
                if(sender.titleLabel!.text == "수락됨"){
                    sender.setTitle("수락", forState: .Normal)
                }
                else{
                    sender.setTitle("수락됨", forState: .Normal)
                }
                
            }
        }
    }
    
    func detailContests(sender: AnyObject){
        performSegueWithIdentifier("ShowArticleDetail_recruit", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowArticleDetail_recruit"{
            
            let detailViewController = segue.destinationViewController as! ArticleDetailViewController
            let row = sender!.tag
            print("row is \(row)")
            
            detailViewController.contests_id = self.recruitList[row]["contests_id"].intValue
            print("prepare for segue: contests_id: \(detailViewController.contests_id)")
            
            //상세정보 받아옴
            
            var content_writer: Int?
            Alamofire.request(.GET, "http://come.n.get.us.to/contests/\(detailViewController.contests_id!)", headers: header).responseJSON{
                response in
                if let responseVal = response.result.value{
                    //print(responseVal["data"])
                    //받아온 정보 contests에 할당
                    let json = JSON(responseVal)
                    
                    detailViewController.contests = json["data"]
                    let stringJSON:JSON = json["data"]["categories"]
                    if let wordsInclude = stringJSON.string?.characters.dropFirst().dropLast().split(",").map(String.init){
                        for words in wordsInclude{
                            detailViewController.categoryArr.append(String(words.characters.dropFirst().dropLast()))
                        }
                    }
                    
                    // 받아온 상세정보 라벨에 집어넣음
                    detailViewController.titleLabel.text = json["data"]["title"].stringValue
                    detailViewController.hostsLabel.text = json["data"]["hosts"].stringValue
                    detailViewController.categoryLabel.text = String(detailViewController.categoryArr)
                    detailViewController.recruitmentLabel.text = json["data"]["recruitment"].stringValue
                    detailViewController.writerLabel.text = json["data"]["cont_writer"].stringValue
                    detailViewController.coverLabel.text = json["data"]["cover"].stringValue
                    detailViewController.appliersLabel.text = json["data"]["appliers"].stringValue
                    detailViewController.kakaoLabel.text = json["data"]["kakao_id"].stringValue
                    
                   
                    
                    //D-day 변환 로직
                    if let dayString:String = json["data"]["period"].stringValue{
                        //String을 NSDate로 변환
                        let formatter = NSDateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                        if let formattedDate = formatter.dateFromString(dayString){
                            //앞의 자리수로 자르고 day라벨에 집어넣기
                            formatter.dateFormat = "yyyy-MM-dd"
                            
                            //D-day 표시
                            let toDate = floor(formattedDate.timeIntervalSinceNow / 3600 / 24)
                            if (toDate > 0){
                                detailViewController.dueDayLabel.text = "D-" + String(Int(toDate))
                            }
                            else{
                                detailViewController.dueDayLabel.text = "마감"
                            }
                            
                        }
                    }
                }
            }
        }
    }
}