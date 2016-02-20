//
//  ScrapListViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class ScrapListViewController: UIViewController {

    @IBAction func backButtonTouch(sender: AnyObject) {
        
        if let container = self.so_containerViewController {
            container.isLeftViewControllerPresented = false
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.so_containerViewController?.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
