//
//  TravelCostViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import SwiftySound

class TravelCostViewController: UIViewController {

    @IBOutlet weak var costFeeLabel: UILabel!
    @IBOutlet weak var totalFeeLabel: UILabel!
    @IBOutlet weak var confirmPaymentBtn: UIButton!
    var costTip: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "行程消费"
        self.navigationItem.leftBarButtonItem = nil
        Sound.play(file: "骑行结束_LH.m4a")
        
        costFeeLabel.text = String(format: "%.2f", Float(costTip))
        totalFeeLabel.text = "总费用\(self.costTip)元"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
     // MARK: - Action
    @IBAction func confirmPaymentBtn(_ sender: Any) {
        self.showHint(hint: "支付费用")
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func voiceBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.showInfo(info: "声音")
        SaveTools.mg_SaveToLocal(value: !sender.isSelected, key: "isVoiceOn")
    }
}
