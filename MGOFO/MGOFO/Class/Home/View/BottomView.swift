//
//  BottomView.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

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
            make.width.equalTo(1.5)
            make.center.equalToSuperview()
            make.height.equalTo(flashBtn.mg_height*0.8)
        }
        
        voiceBtn.isSelected = (SaveTools.mg_getLocalData(key: "isVoiceOn") == nil)
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
        SaveTools.mg_SaveToLocal(value: !btn.isSelected, key: "isVoiceOn")
        
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
