//
//  Get 车牌 plate number; licence plate; 车牌号 名 plate number; 车牌号码 名 license plate; GetLicensePlateViewController 车牌号 GetLicensePlateNumber.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import SwiftySound
import SwiftyTimer

class GetLicensePlateNumberVC: UIViewController {

    weak var superVC: UIViewController?
    fileprivate var countDownLabel: UILabel!
    var remindTimerNumber: Int = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        setUpMainView()
        setUpNavgationItem()
        
        Sound.play(file: "上车前_LH.m4a")
        
        Timer.every(1) { (timer: Timer) in
            self.remindTimerNumber -= 1
            self.countDownLabel.text = "\(self.remindTimerNumber)秒开始计费，请检查车辆"
            if self.remindTimerNumber == 0 {
                
                timer.invalidate()
            }
        }
    }
    
    fileprivate func setUpNavgationItem() {
        self.title = "车辆解锁"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "如何开锁", style: .done, target: self, action: #selector(helpUnlock))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationButtonReturnClick"), highImage: #imageLiteral(resourceName: "navigationButtonReturnClick"), norColor: UIColor.darkGray, selColor: UIColor.lightGray, title: "返回", target: self, action: #selector(GetLicensePlateNumberVC.popClick(_:)))
    }
    
    @objc fileprivate func popClick(_ sender: UIButton) {
        let _ = superVC?.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func helpUnlock() {
        let _ = superVC?.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: setUpMainView
extension GetLicensePlateNumberVC {
    fileprivate func setUpMainView() {
        /// 顶部
        let topView = TopView()
        let bottomView = BottomView()
        bottomView.backgroundColor = UIColor.randomColor()
        
        countDownLabel = UILabel()
        countDownLabel.textAlignment = .center
        
        let repairTipLabel = UILabel()
        repairTipLabel.text = "如有问题，"
        repairTipLabel.sizeToFit()
        
        let repairBtn = UIButton(title: "立即报修", target: self, action: #selector(            immediateRepair))
        repairBtn.setTitleColor(UIColor.blue, for: .normal)
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addSubview(countDownLabel)
        view.addSubview(repairBtn)
        view.addSubview(repairTipLabel)
        
        /// 布局
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(navHeight+MGGloabalMargin)
            make.left.equalToSuperview().offset(MGGloabalMargin)
            make.right.equalToSuperview().offset(-MGGloabalMargin)
            make.height.equalTo(240)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(MGGloabalMargin)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(180)
        }
        
        repairTipLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(repairTipLabel.mg_width/2)
            make.centerY.equalTo(repairBtn)
        }
        
        repairBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(repairBtn.mg_width/2)
            
            make.bottom.equalToSuperview().offset(-30)
        }
        
        countDownLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(repairBtn.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        
        // 控制数据(假数据)
        topView.inputTextField.isHidden = true
        topView.sureBtn.isHidden = true
        topView.imageV.image = #imageLiteral(resourceName: "smartLock_340x135_")
        topView.chargingLabel.text = "车牌号为09329的解锁码"
        topView.resultLabel.text = "3222"
        topView.descripLabel.text = "骑行结束后，记得在手机上结束行程"
    }
    
    @objc fileprivate func immediateRepair() {
        
    }
}
