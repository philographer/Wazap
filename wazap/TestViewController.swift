//
//  TestViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 6. 30..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class TestViewController: SOContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuSide = .Left
        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        self.sideViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftScreen")

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
