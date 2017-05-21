//
//  TravelCostViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class TravelCostViewController: UIViewController {

    @IBOutlet weak var costFeeLabel: UILabel!
    @IBOutlet weak var totalFeeLabel: UILabel!
    @IBOutlet weak var confirmPaymentBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "行程消费"
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
     // MARK: - Action
    @IBAction func confirmPaymentBtn(_ sender: Any) {
    }

    @IBAction func voiceBtnClick(_ sender: UIButton) {
    }
}
