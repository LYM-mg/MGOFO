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
