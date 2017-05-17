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
import MediaPlayer

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
        self.title = "车辆解锁"
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫码用车", style: .done, target: self, action: #selector(backToScan))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationButtonReturnClick"), highImage: #imageLiteral(resourceName: "navigationButtonReturnClick"), norColor: UIColor.darkGray, selColor: UIColor.lightGray, title: "返回", target: self, action: #selector(ManuallyEnterLicenseVC.popClick(_:)))
        setUpMainView()
    }
    
    @objc fileprivate func popClick(_ sender: UIButton) {
        let _ = superVC?.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func backToScan() {
        let _ = superVC?.navigationController?.popViewController(animated: true)
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
        setUpNavgationItem()
        
        /// 顶部
        let topView = TopView()
        let bottomView = BottomView()
        bottomView.backgroundColor = UIColor.randomColor()
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        
        topView.sureBtnBlock = {
            let firstController: UIViewController? = self.superVC?.childViewControllers[0]
            let secondController: UIViewController? = self.superVC?.childViewControllers[1]
            let oldController: UIViewController = (self.superVC?.currentViewController)!

            self.superVC?.transition(from: oldController, to: secondController!, duration: 1, options: .transitionFlipFromLeft, animations: {() -> Void in
            }, completion: {(_ finished: Bool) -> Void in
                if finished {
                   self.superVC?.currentViewController = secondController
                    self.view.addSubview((self.superVC?.currentViewController.view)!)
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
            make.height.equalTo(240)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(MGGloabalMargin)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(180)
        }
    }
    
    fileprivate func setUpNavgationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "帮助", style: .done, target: self, action: #selector(
            explainClick(_:)))
    }
    
    @objc fileprivate func explainClick(_ item: UIBarButtonItem) {
        MGKeyWindow?.addSubview(ExplainView.showInPoint(point: CGPoint(x: MGScreenW-45, y: 45)))
    }
}

// MARK: - 顶部
class TopView: UIView,UITextFieldDelegate,APNumberPadDelegate {
    var sureBtn: UIButton!
    var descripLabel: UILabel!
    var sureBtnBlock: (() -> ())?
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
        chargingLabel.layer.cornerRadius = 10
        chargingLabel.clipsToBounds = true
        chargingLabel.textColor = UIColor(r: 152, g: 147, b: 130)
        chargingLabel.text = "计费说明：1小时/1元"
        chargingLabel.font = UIFont.systemFont(ofSize: 16)
        chargingLabel.textAlignment = .center
        
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
        sureBtn.isEnabled = false
        
        descripLabel = UILabel()
        descripLabel.font = UIFont.systemFont(ofSize: 14)
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
            make.width.equalTo(160)
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
        if sureBtnBlock != nil {
            sureBtnBlock!()
        }
    }
    
    // MARK: - UITextFieldDelegate,APNumberPadDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // guard let text = textField.text else { return true }
        let textLength = range.location + 1
        sureBtn.isEnabled = textLength > 0
        if textLength > 0 {
            sureBtn.setImage(#imageLiteral(resourceName: "nextArrow_enable_25x19_"), for: .normal)
            sureBtn.backgroundColor = UIColor(r: 247, g: 215, b: 81)
        } else {
            sureBtn.setImage(UIImage(named: "nextArrow_unenable_25x19_"), for: .normal)
            sureBtn.backgroundColor = UIColor.groupTableViewBackground
        }
        if textLength >= 8 {
            self.showInfo(info: "你只能输入8位数的车牌号")
        }else if 4 <= textLength && textLength < 8 {
            descripLabel.text = "若输入车牌号错误，无法正确打开车锁"
        }else if 1 < textLength  && textLength < 4 {
            descripLabel.text = "车牌号为4~8位"
        }else {
            descripLabel.text = "输入车牌号，获取解码锁"
        }
        return textLength <= 8
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
        
        let volumeView = MPVolumeView()
        var volumeViewSlider: UISlider? = nil
        for view: UIView in volumeView.subviews {
            if (view.self.description == "MPVolumeSlider") {
                volumeViewSlider = (view as? UISlider)
                break
            }
        }
        let value: Float = btn.isSelected ? 0 : 1
        volumeViewSlider?.setValue(value, animated: false)
        // send UI control event to make the change effect right now.
        volumeViewSlider?.sendActions(for: .touchUpInside)
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

// AMRK: - ExplainView
class ExplainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(r: 10, g: 10, b: 10, a: 0.9)
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
        let helpImageV = UIImageView(image: #imageLiteral(resourceName: "guide_QRhelp_354x474_"))
        addSubview(helpImageV)
        
        helpImageV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(MGScreenW*0.82)
            make.height.equalTo(MGScreenH*0.73)
        }
    }
}

// AMRK: - 出现和消失的方法
extension ExplainView {
    /// 隐藏并且隐藏的中心的位置以及隐藏之后的回调操作
    /// 创建出来并且出现的中心的位置
    static func showInPoint(point: CGPoint) -> ExplainView{
        let bigPictureView = ExplainView(frame: MGScreenBounds)
        
        bigPictureView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 1.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            bigPictureView.transform = CGAffineTransform.identity
             bigPictureView.center = CGPoint(x: MGScreenW/2, y: MGScreenH/2)
        }) { (isFinished) in
            
        }

        return bigPictureView
    }
    
    
    func hideInPoint(point: CGPoint, completion: (()->())?) {
        UIView.animate(withDuration: 1.2, animations: {
            self.center = point
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.15)
        }) { (isFinished) in
            self.removeFromSuperview()      // 从父控件中移除FilterView
            if completion != nil {
                completion!()               // 移除view之后的操作（回调）
            }
        }
    }
}
