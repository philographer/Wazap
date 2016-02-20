//
//  ViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 19..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit
import SidebarOverlay
import FontAwesome

class ViewController : SOContainerViewController {
    @IBOutlet weak var mainLabel: UILabel!
    @IBAction func returned(segue: UIStoryboard){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        self.leftViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftScreen")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

