//
//  LocationViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 6. 26..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import FBSDKLoginKit

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ChildNameDelegate?
    
    
    
    let header = ["access-token": FBSDKAccessToken.currentAccessToken().tokenString as String]
    
    let locationArr: [String] = ["강원도", "경기도", "경상남도", "경상북도", "광주광역시", "대구광역시", "대전광역시", "부산광역시", "서울특별시", "울산광역시", "인천광역시", "전라남도", "전라북도", "제주특별자치도", "충청남도", "충청북도"]
    
    let locationDetailArr = [["춘천시","원주시", "강릉시", "동해시", "태백시", "속초시", "삼척시", "홍천군", "횡성군", "철원군", "화천군", "양구군", "인제군", "고성군", "양양군" ],["수원시 장안구", "수원시 권선구", "수원시 팔달구", "성남시 수정구", "성남시 분당구", "의정부시", "안양시 만안구", "안양시 동안구", "부천시 원미구", "부천시 소사구", "부천시 오정구", "광명시", "평택시", "동두천시", "안산시 단원구", "고양시 덕양구", "고양시 일산동구", "과천시", "구리시", "남양주시", "오산시", "시흥시", "군포시", "하남시", "용인시 처인구", "용인시 수지구", "파주시", "이천시", "안성시", "김포시", "화성시", "광주시", "양주시", "포천시", "여주시", "연천군", "가평군", "양평군"],[ "창원시 성산구", "창원시 마산합포구", "창원시 마산회원구", "창원시 진해구", "진주시", "통영시", "사천시", "김해시", "밀양시", "거제시", "양산시", "의령군", "함안군", "창녕군", "고성군", "남해군", "하동군", "산청군", "함양군", "거창군", "합천군"],[ "포항시 남구", "포항시 북구", "경주시", "김천시", "안동시", "구미시", "영주시", "영천시", "상주시", "문경시", "경산시", "군위군", "의성군", "청송군", "영덕군", "청도군", "성주군", "칠곡군", "예천군", "봉화군", "울진군", "울릉군"],[ "동구", "서구", "북구", "광산구"],[ "중구", "동구", "서구", "남구", "북구", "수성구", "달서구", "달성군"],[ "동구", "중구", "서구", "유성구", "대덕구"],[ "중구", "동구", "영도구", "부산진구", "동래구", "북구", "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장군"],[ "종로구", "중구", "용산구", "광진구", "동대문구", "중랑구", "성북구", "도봉구", "노원구", "은평구", "서대문구", "마포구", "양천구", "강서구", "구로구", "금천구", "영등포구", "동작구", "관악구", "서초구", "강남구", "송파구", "강동구"],[ "중구", "남구", "동구", "울주군"],[ "중구", "연수구", "남동구", "부평구", "계양구", "서구", "강화군", "옹진군"],[ "목포시", "여수시", "순천시", "나주시", "광양시", "담양군", "곡성군", "구례군", "고흥군", "보성군", "화순군", "장흥군", "강진군", "해남군", "영암군", "무안군", "함평군", "영광군", "장성군", "완도군", "진도군"],[ "전주시 완산구", "전주시 덕진구", "군산시", "익산시", "정읍시", "남원시", "김제시", "완주군", "진안군", "무주군", "장수군", "임실군", "순창군", "고창군", "부안군"],[ "제주시", "서귀포시"], [ "천안시 동남구", "천안시 서북구", "공주시", "보령시", "아산시", "서산시", "논산시", "계룡시", "당진시"],[ "청주시 상당구", "청주시 흥덕구", "청주시 청원구", "충주시", "제천시", "증평군", "괴산군", "단양군"]]
    
    /// The number of elements in the data source
    var total = 0
    
    /// The data source
    var dataSource: [StringParent]!
    
    
    /// Define wether can exist several cells expanded or not.
    let numberOfCellsExpanded: NumberOfCellExpanded = .One
    
    /// Constant to define the values for the tuple in case of not exist a cell expanded.
    let NoCellExpanded = (-1, -1)
    
    /// The index of the last cell expanded and its parent.
    var lastCellExpanded : (Int, Int)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialDataSource(numberOfRowParents: 16, numberOfRowChildPerParent: 38)
        self.lastCellExpanded = self.NoCellExpanded
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCellWithIdentifier("LocationHeaderCell") as! LocationTableViewHeaderCell
        /*
        headerCell.titleLabel.text = "지역을 선택해 주세요!"
        
        headerCell.awakeFromNib()
        
        headerCell.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        headerCell.translatesAutoresizingMaskIntoConstraints = true
        headerCell.contentView.backgroundColor = UIColor.whiteColor()
        */
        headerCell.closeButton.addTarget(self, action: #selector(self.closeTable(_:)), forControlEvents: .TouchUpInside)
 
        
        let view = UIView(frame: headerCell.frame)
        headerCell.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        view.addSubview(headerCell)
        
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let (parent, isParentCell, _) = self.findParent(indexPath.row)
        
        if isParentCell{ //부모셀 클릭
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! LocationTableViewParentCell
            cell.expandButton.sendActionsForControlEvents(.TouchUpInside)
            

        }else{ //자식셀 클릭
            //NSLog("A child was tapped!!!")
            let a = self.dataSource[parent].parentData
            let childCell = self.tableView.cellForRowAtIndexPath(indexPath) as! LocationTableViewChildCell
            
            
            //이 데이터 부모로 전달.
            if let del = delegate {
                del.dataChanged(a + " " + childCell.detailLocation.text!)
            }
            
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let (parent, isParentCell, actualPosition) = self.findParent(indexPath.row)
        
        if !isParentCell { //자식셀
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationChildCell", forIndexPath: indexPath) as! LocationTableViewChildCell
            let str = self.dataSource[parent].childs[indexPath.row - actualPosition - 1]
            cell.detailLocation.text = str
            return cell
        }else{ //부모셀
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationParentCell", forIndexPath: indexPath) as! LocationTableViewParentCell
            cell.location.text = self.locationArr[parent]
            cell.expandButton.tag = parent
            cell.expandButton.addTarget(self, action: #selector(self.showDetail(_:)), forControlEvents: .TouchUpInside)
            return cell
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    func closeTable(sender: UIButton){
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func showDetail(sender: AnyObject){
        
        
        
        
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! LocationTableViewParentCell
        let indexPath = self.tableView.indexPathForCell(cell)!
        
        let (parent, _, _) = self.findParent(indexPath.row)
        self.tableView.beginUpdates()
        self.updateCells(parent, index: indexPath.row)
        self.tableView.endUpdates()
        
        
        
        
        /*
        let indexPaths = (0 ..< rowTotal).map { i in
            
            let (_,is_parent,_) = self.findParent(i)
            
            print(is_parent)
            
        }
        
        print(indexPaths)
        */
    }
    
    
    /**
     Set the initial data for test the table view.
     
     - parameter parents: The number of parents cells
     - parameter childs:  Then maximun number of child cells per parent.
     */
    private func setInitialDataSource(numberOfRowParents parents: Int, numberOfRowChildPerParent childs: Int) {
        
        // Set the total of cells initially.
        self.total = parents
        
        let data = [StringParent](count: parents, repeatedValue: StringParent(state: .Collapsed, childs: [String](), parentData: ""))
        
        dataSource = data.enumerate().map({ (index: Int, element: StringParent) -> StringParent in
            
            var element = element
            element.parentData = self.locationArr[index]
            element.childs = self.locationDetailArr[index]
            /*
            for i in  0 ... detailLocationArr[index].count-1 {
                element.childs.append(detailLocationArr[index][i])
            }
            */
            
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
        let insertPos:Int = index
        
        // create an array of NSIndexPath with the selected positions
        
        let indexPaths = (0..<currentSubItems.count).map { i in
            NSIndexPath(forRow: insertPos + i+1, inSection: 0)
        }
        
        
        
        //문제가 되면 원래 insertPos ++;로 고칠것
        
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
        
        
        
        //print("Index \(index)")
        //print("Parent \(parent)")
        
        var indexPaths = [NSIndexPath]()
        let numberOfChilds = self.dataSource[parent].childs.count
        
        // update the state of the cell.
        self.dataSource[parent].state = .Collapsed
        
        // create an array of NSIndexPath with the selected positions
        //print("collapsed index is \(index)")
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
                    
                    let indexPah = NSIndexPath(forRow: index, inSection: 0)
                    let cell = self.tableView.cellForRowAtIndexPath(indexPah) as! LocationTableViewParentCell
                    cell.expandButton.setImage(UIImage(named: "location_triangle_on"), forState: .Normal)
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
