//
//  MyWalletViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/12.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的钱包"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 按钮点击
    @IBAction func balanceStatement(_ sender: UIButton) {
        self.showHint(hint: "余额说明")
    }
    
    @IBAction func rechargeBtnClick(_ sender: UIButton) {
        self.showHint(hint: "充值")
    }
}
