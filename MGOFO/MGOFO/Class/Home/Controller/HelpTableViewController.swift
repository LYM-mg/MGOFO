//
//  HeLpTableViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class HelpTableViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "你好"
        scrollView.contentSize = CGSize(width: MGScreenW, height: 474*8)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
