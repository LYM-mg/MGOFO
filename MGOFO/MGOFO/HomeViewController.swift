//
//  HomeViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/10.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavgationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - 设置导航栏相关
extension HomeViewController {
    fileprivate func initNavgationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "leftTopImage_20x20_"), style: .plain, target: nil, action: nil)
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ofoLogo_83x18_"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "rightTopImage_20x20_"), style: .plain, target: nil, action: nil)
    }
}
