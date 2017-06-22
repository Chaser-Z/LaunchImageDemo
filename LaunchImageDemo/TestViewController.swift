//
//  TestViewController.swift
//  LaunchImageDemo
//
//  Created by yeeaoo on 16/6/27.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let url = URL(string: "https://itunes.apple.com/cn/app/it-blog-for-ios-developers/id1067787090?mt=8")
        UIApplication.shared.openURL(url!)
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
