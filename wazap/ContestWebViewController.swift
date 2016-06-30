//
//  ContestWebViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 6. 24..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class ContestWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlWebView : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: urlWebView!)!))
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
