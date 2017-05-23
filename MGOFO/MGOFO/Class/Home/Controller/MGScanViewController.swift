//
//  MGScanViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/10.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit

class MGScanViewController: LBXScanViewController {

    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash:Bool = false
    
    // MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
    fileprivate lazy var scanBottom: ScanBottomView = {
        let sb = ScanBottomView(frame: CGRect(x: 0, y: MGScreenH-120-navHeight, width: MGScreenW, height: 120))
        return sb
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫描用车"
        
        var style = LBXScanViewStyle()
        style.anmiationStyle = .NetGrid
        style.animationImage = UIImage(named: "MGCodeScan.bundle/qrcode_scan_full_net")
        self.scanStyle = style
        
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)
        
        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
        
        view.addSubview(scanBottom)
        bottomViewClick()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "帮助", style: .done, target: self, action: #selector(
            explainClick(_:)))
    }
    
    @objc fileprivate func explainClick(_ item: UIBarButtonItem) {
        self.view.endEditing(true)
        MGKeyWindow?.addSubview(ExplainView.showInPoint(point: CGPoint(x: MGScreenW-45, y: 45)))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.darkText
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubview(toFront: scanBottom)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.tintColor = UIColor(r: 124, g: 116, b: 100)
        self.navigationController?.navigationBar.barTintColor = UIColor.lightText
    }
    
    /// 处理扫描到的结果
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        for result:LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print(str)
            }
        }
        
        let result:LBXScanResult = arrayResult[0]
        if result.strScanned!.contains("http://") || result.strScanned!.contains("https://") {
            let url = URL(string: result.strScanned!)
            if  UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        } else {  // 其他信息 弹框显示
            self.showHint(hint: result.strScanned!)
        }
    }
    
    // 底部按钮操作
    fileprivate func bottomViewClick() {
        scanBottom.btnClickBlcok = { [unowned self](view,btn, type) in
            switch type {
                case .flash:
                    self.scanObj?.changeTorch();
                    
                    self.isOpenedFlash = !self.isOpenedFlash
                    
                    if self.isOpenedFlash {
                        btn.setImage(UIImage(named: "btn_enableTorch_45x45_"), for:UIControlState.normal)
                    } else {
                        btn.setImage(UIImage(named: "btn_unenableTorch_45x45_")!, for:UIControlState.normal)
                    }
                case .intput:
                    self.show(EnterLicenseViewController(), sender: nil)
                case .photo:
                    
                    break
                case .myqrcode:
                    self.showHint(hint: "我的二维码")
                    // self.show(QRCodeViewController(), sender: nil)
                    break
            }
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

