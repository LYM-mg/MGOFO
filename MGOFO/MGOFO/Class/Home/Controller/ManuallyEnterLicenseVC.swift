//
//  ManuallyEnterLicenseVC.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/15.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//  手动输入车牌号解锁

import UIKit
/*
import AVKit
import AudioToolbox
import CoreAudioKit
import CoreAudio
 */

class ManuallyEnterLicenseVC: UIViewController {

    weak var superVC: EnterLicenseViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        setUpNavgationItem()
        setUpMainView()
    }
    
    fileprivate func setUpNavgationItem() {
        self.title = "车辆解锁"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫码用车", style: .done, target: self, action: #selector(backToScan))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationButtonReturnClick"), highImage: #imageLiteral(resourceName: "navigationButtonReturnClick"), norColor: UIColor.darkGray, selColor: UIColor.lightGray, title: "返回", target: self, action: #selector(ManuallyEnterLicenseVC.popClick(_:)))
    }
    
    @objc fileprivate func popClick(_ sender: UIButton) {
        let _ = superVC?.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func backToScan() {
        let _ = superVC?.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

// MARK: - setUpMainView
extension ManuallyEnterLicenseVC {
    // MARK: setUpMainView
    fileprivate func setUpMainView() {
        self.automaticallyAdjustsScrollViewInsets = false
        setUpNavgationItem()
        
        /// 顶部
        let topView = TopView()
        topView.resultLabel.isHidden = true
        let bottomView = BottomView()
        bottomView.backgroundColor = UIColor.randomColor()
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        
        topView.sureBtnBlock = {
            let secondController: UINavigationController? = self.superVC?.childViewControllers[1] as? UINavigationController
            let oldController: UIViewController = (self.superVC?.currentViewController)!

            self.superVC?.transition(from: oldController, to: secondController!, duration: 1, options: .transitionFlipFromLeft, animations: {() -> Void in
            }, completion: {(_ finished: Bool) -> Void in
                if finished {
                    // 隐藏返回(这时候无法pop回去上一个界面，否则就无法正常计费，导致BUG)
                    (self.superVC?.navigationController as! BaseNavigationController).popBtn.isHidden = true
                    (self.superVC?.navigationController as! BaseNavigationController).removeGlobalPanGes()
                    
                    (secondController?.childViewControllers[0] as! GetLicensePlateNumberVC).byeCycleNumber = topView.inputTextField.text!
                   (secondController?.childViewControllers[0] as! GetLicensePlateNumberVC).startPlay()
                   self.superVC?.currentViewController = secondController
                   self.superVC?.view.addSubview((self.superVC?.currentViewController.view)!)
                }
                else {
                    self.superVC?.currentViewController = oldController
                }
            })
        }
        
        /// 布局
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(navHeight+MGGloabalMargin)
            make.left.equalToSuperview().offset(MGGloabalMargin)
            make.right.equalToSuperview().offset(-MGGloabalMargin)
            // make.height.equalTo(240)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(MGGloabalMargin)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(180)
        }
    }
}
