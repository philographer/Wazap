//
//  applyViewController.swift
//  wazap
//
//  Created by 유호균 on 2016. 2. 20..
//  Copyright © 2016년 nexters. All rights reserved.
//

import UIKit

class ApplyViewController: UIViewController {
    
    @IBAction func backButtonTouch(sender: AnyObject) {
        
        /*
        if let container = self.so_containerViewController {
            container.isLeftViewControllerPresented = true
        }
        */
        
        fadeOut()
        
        self.so_containerViewController!.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainScreen")
        
        
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.view.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.alpha = 0.0
            }, completion: nil)
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
