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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "帮助", style: .done, target: self, action: #selector(
            explainClick(_:)))
    }
    
    @objc fileprivate func explainClick(_ item: UIBarButtonItem) {
        self.view.endEditing(true)
        MGKeyWindow?.addSubview(ExplainView.showInPoint(point: CGPoint(x: MGScreenW-45, y: 45)))
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
            // let firstController: UIViewController? = self.superVC?.childViewControllers[0]
            let secondController: UINavigationController? = self.superVC?.childViewControllers[1] as? UINavigationController
            let oldController: UIViewController = (self.superVC?.currentViewController)!

            self.superVC?.transition(from: oldController, to: secondController!, duration: 1, options: .transitionFlipFromLeft, animations: {() -> Void in
            }, completion: {(_ finished: Bool) -> Void in
                if finished {
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


// AMRK: - ExplainView
class ExplainView: UIView {
    fileprivate var helpImageV: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(r: 50, g: 50, b: 50, a: 0.9)
        self.frame = MGScreenBounds
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClick)))
        setUpUI()
    }
    
    @objc fileprivate func tapClick() {
        self.hideInPoint(point: CGPoint(x: MGScreenW-45, y: 45), completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpUI(){
        helpImageV = UIImageView(image: #imageLiteral(resourceName: "guide_QRhelp_354x474_"))
        let closeBtn = UIButton(image: #imageLiteral(resourceName: "Refund_close_12x12_"), bgImage: #imageLiteral(resourceName: "userBikeImage_100x100_"), target: self, action: #selector(tapClick))
        addSubview(helpImageV)
        addSubview(closeBtn)
        
        helpImageV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(MGScreenW*0.82)
            make.height.equalTo(MGScreenH*0.73)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(helpImageV.snp.bottom).offset(35)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
    }
}

// AMRK: - 出现和消失的方法
extension ExplainView {
    /// 隐藏并且隐藏的中心的位置以及隐藏之后的回调操作
    /// 创建出来并且出现的中心的位置
    static func showInPoint(point: CGPoint) -> ExplainView{
        let bigPictureView = ExplainView(frame: MGScreenBounds)
        bigPictureView.helpImageV.center = point
        bigPictureView.helpImageV.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 1.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            bigPictureView.helpImageV.transform = CGAffineTransform.identity
            bigPictureView.helpImageV.center = CGPoint(x: MGScreenW/2, y: MGScreenH/2)
        }) { (isFinished) in
            
        }

        return bigPictureView
    }
    
    
    func hideInPoint(point: CGPoint, completion: (()->())?) {
        UIView.animate(withDuration: 1.2, animations: {
            self.helpImageV.center = point
            self.helpImageV.transform = CGAffineTransform(scaleX: 0.005, y: 0.005)
        }) { (isFinished) in
            self.removeFromSuperview()      // 从父控件中移除FilterView
            if completion != nil {
                completion!()               // 移除view之后的操作（回调）
            }
        }
    }
}
