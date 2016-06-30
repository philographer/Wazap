//
//  ContestsDetailViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 6. 23..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class ContestsDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var hostingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var benefitLabel: UILabel!
    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var contestTitle: String?
    var tag: String?
    var hosting: String?
    var date: String?
    var target: String?
    var benefit: String?
    var prize: String?
    var homepage: String?
    var image: String?
    var dueDay: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.contestTitle
        self.tagLabel.text = self.tag
        self.hostingLabel.text = self.hosting
        self.dateLabel.text = self.date
        self.benefitLabel.text = self.benefit
        self.prizeLabel.text = self.prize
        self.homepageLabel.text = self.homepage
        self.imageView.kf_setImageWithURL(NSURL(string: self.image!)!)
        self.dueDayLabel.text = self.dueDay
        self.targetLabel.text = self.target

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.movePage(_:)))
        self.homepageLabel.addGestureRecognizer(tap)
        self.homepageLabel.userInteractionEnabled = true
        
        var titleView : UIImageView
        // set the dimensions you want here
        titleView = UIImageView(frame:CGRectMake(-20, 0, 50, 40))
        // Set how do you want to maintain the aspect
        titleView.contentMode = .ScaleAspectFit
        titleView.image = UIImage(named: "detail_title_banner-4")
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func movePage(sender: UITapGestureRecognizer){
        print("touch")
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContestWebViewController") as! ContestWebViewController
        viewController.urlWebView = self.homepage
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
