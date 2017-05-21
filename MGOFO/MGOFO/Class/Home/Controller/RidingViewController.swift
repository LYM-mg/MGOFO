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
    fileprivate var remindTimerNumber: Int = 0
    fileprivate var costTip: Int = 0
    var timer: Timer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "骑行中"
        self.navigationItem.leftBarButtonItem = nil
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateTime() {
        self.remindTimerNumber += 1
        self.timeLabel.text = MGTimeTool.getFormatTimeWithTimeInterval(timeInterval: Double(self.remindTimerNumber))
        switch self.remindTimerNumber/3600 {
        case 0:
            self.costTip = 1
        case 1:
            self.costTip = 2
        case 2:
            self.costTip = 3
        case 3:
            self.costTip = 4
        case 4:
            self.costTip = 5
        case 5:
            self.costTip = 6
        default:
            self.costTip =  (self.costTip > 6) ? 6 : 0
            break
        }
        self.costLabel.text = "当前费用\(self.costTip)元"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    // MARK: - Action
    @IBAction func endRadingBtnClick(_ sender: UIButton) {
        timer == nil
        timer?.invalidate()
        let vc = TravelCostViewController(nibName: "TravelCostViewController", bundle: nil)
        vc.costTip =  self.costTip
        self.show(vc, sender: nil)
    }

    @IBAction func SafetyInsuranceBtnClick(_ sender: UIButton) {
        self.showHint(hint: "安全出行")
    }
}
