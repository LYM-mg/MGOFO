//
//  RidingViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class RidingViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var endRadingBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "骑行"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action
    @IBAction func endRadingBtnClick(_ sender: UIButton) {
    }

    @IBAction func SafetyInsuranceBtnClick(_ sender: UIButton) {
    }
}
