//
//  ManuallyEnterLicenseVC.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/15.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//  手动输入车牌号解锁

import UIKit
import AVFoundation
import APNumberPad
/*
import AVKit
import AudioToolbox
import CoreAudioKit
import CoreAudio
 */

class ManuallyEnterLicenseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "车辆解锁"
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫码用车", style: .done, target: self, action: #selector(backToScan))
        setUpMainView()
    }
    
    @objc fileprivate func backToScan() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

// MARK: - Navigation
extension ManuallyEnterLicenseVC {
    // MARK: setUpMainView
    fileprivate func setUpMainView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        /// 顶部
        let topView = TopView()
        let bottomView = BottomView()
        // bottomView.backgroundColor = UIColor.randomColor()
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        
        
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
    }
}

// MARK: - 顶部
class TopView: UIView,UITextFieldDelegate,APNumberPadDelegate {
    var sureBtn: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = .zero

        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpUI() {
        // 1.创建UI
        self.backgroundColor = UIColor.white
        let imageV = UIImageView(image: #imageLiteral(resourceName: "inputPageImage_340x117_"))
        let chargingLabel = UILabel()
        chargingLabel.backgroundColor = UIColor.groupTableViewBackground
        chargingLabel.layer.cornerRadius = 3
        chargingLabel.clipsToBounds = true
        chargingLabel.textColor = UIColor(r: 152, g: 147, b: 130)
        chargingLabel.text = "计费说明：1小时/1元"
        chargingLabel.font = UIFont.systemFont(ofSize: 14)
        chargingLabel.sizeToFit()
        
        let inputTextField = UITextField()
        inputTextField.placeholder = "请输入车牌号"
        inputTextField.keyboardType = .numbersAndPunctuation
        inputTextField.textAlignment = .center
        inputTextField.borderStyle = .roundedRect
        inputTextField.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 25) // "HelveticaNeue-CondensedBlack"
        inputTextField.clearButtonMode = .never // //设置一键清除按钮是否出现
        inputTextField.clearsOnBeginEditing = false // 默认
        inputTextField.tintColor = UIColor(r: 247, g: 215, b: 81)
        inputTextField.layer.borderColor = UIColor(r: 247, g: 215, b: 81).cgColor
        inputTextField.layer.borderWidth = 2
        let numberPad = APNumberPad(delegate: self)
        numberPad.leftFunctionButton.setTitle("确定", for: .normal)
        inputTextField.inputView = numberPad
        inputTextField.delegate = self
        
        sureBtn = UIButton(image: #imageLiteral(resourceName: "nextArrow_enable_25x19_"), bgImage: nil, target: self, action: #selector(sureBtnClick(_:)))
        sureBtn.backgroundColor = UIColor.groupTableViewBackground
        
        let descripLabel = UILabel()
        descripLabel.font = UIFont.systemFont(ofSize: 17)
        descripLabel.textColor = UIColor(r: 152, g: 147, b: 130)
        descripLabel.text = "输入车牌号，获取解码锁"
        
        self.addSubview(imageV)
        self.addSubview(chargingLabel)
        self.addSubview(inputTextField)
        self.addSubview(sureBtn)
        self.addSubview(descripLabel)
        
        // 2.布局
        imageV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.left.right.equalToSuperview()
            make.height.width.equalTo(120)
        }
        chargingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageV.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        inputTextField.snp.makeConstraints { (make) in
            make.top.equalTo(chargingLabel.snp.bottom).offset(MGGloabalMargin)
            make.left.equalToSuperview().offset(30)
            make.right.equalTo(sureBtn.snp.left).offset(-MGGloabalMargin/2)
            make.height.equalTo(sureBtn)
        }
        sureBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalTo(inputTextField)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        descripLabel.snp.makeConstraints { (make) in
            make.top.equalTo(inputTextField.snp.bottom).offset(MGGloabalMargin)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc fileprivate func sureBtnClick(_ btn: UIButton) {
        self.showInfo(info: "确定")
    }
    
    // MARK: - UITextFieldDelegate,APNumberPadDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // guard let text = textField.text else { return true }
        let textLength = range.location
        if textLength > 0 {
            sureBtn.setImage(#imageLiteral(resourceName: "nextArrow_enable_25x19_"), for: .normal)
            sureBtn.backgroundColor = UIColor(r: 247, g: 215, b: 81)
        } else {
            sureBtn.setImage(UIImage(named: "nextArrow_unenable_25x19_"), for: .normal)
            sureBtn.backgroundColor = UIColor.groupTableViewBackground
        }
        if textLength >= 8 {
            self.showInfo(info: "你只能输入8位数的车牌号")
        }
        return textLength < 8
    }
    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder) {
        sureBtnClick(functionButton)
    }
}

// MARK: - 底部
class BottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpUI() {
        // 1.创建UI
        let flashBtn = UIButton(image: #imageLiteral(resourceName: "btn_unenableTorch_45x45_"), selectedImage: #imageLiteral(resourceName: "btn_enableTorch_45x45_"), target: self, action: #selector(flashBtnClick(_:)))
        
        let voiceBtn = UIButton(image: #imageLiteral(resourceName: "voiceopen_45x45_"), selectedImage: #imageLiteral(resourceName: "voiceclose_45x45_"), target: self, action: #selector(voiceBtnClick(_:)))
        
        let seperateView = UIView()
        seperateView.backgroundColor = UIColor.groupTableViewBackground
       
        self.addSubview(flashBtn)
        self.addSubview(voiceBtn)
        self.addSubview(seperateView)
        
        // 2.布局
        flashBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.height.equalTo(80)
        }
        voiceBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.height.equalTo(flashBtn)
        }
        seperateView.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.center.height.equalToSuperview()
        }
    }
    
    @objc fileprivate func flashBtnClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
        // 3.创建新的input
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            self.showInfo(info: "没有输入设备")
            return
        }
        //修改前必须先锁定
        try? device.lockForConfiguration()
        //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
        if device.hasFlash && device.hasTorch {
            if device.flashMode == .off {
                device.flashMode = .on
                device.torchMode = .on
            }else {
                device.flashMode = AVCaptureFlashMode.off
                device.torchMode = AVCaptureTorchMode.off
            }
        }
        device.unlockForConfiguration()
    }
    @objc fileprivate func voiceBtnClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.showInfo(info: "声音")
        /*
        if CDAudioManager.shared.mute == true {
            CDAudioManager.shared.mute = false
        }
        else {
            CDAudioManager.shared.mute = true
        }
         */
    }
}
