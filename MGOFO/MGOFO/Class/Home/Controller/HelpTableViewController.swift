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
        self.title = "帮助"
    
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationButtonReturnClick"), highImage: #imageLiteral(resourceName: "navigationButtonReturnClick"), norColor: UIColor.darkGray, selColor: UIColor.lightGray, title: "返回", target: self, action: #selector(HelpTableViewController.popClick(_:)))
    }

    @objc fileprivate func popClick(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: MGScreenW, height: (474+10)*4)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
}
