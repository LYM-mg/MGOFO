//
//  TopView.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import APNumberPad


// MARK: - 顶部
class TopView: UIView,UITextFieldDelegate,APNumberPadDelegate {
    var sureBtn: UIButton!
    var chargingLabel: UILabel!
    var descripLabel: UILabel!
    var resultLabel: UILabel!
    var imageV: UIImageView!
    var inputTextField: UITextField!
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
        imageV = UIImageView(image: #imageLiteral(resourceName: "inputPageImage_340x117_"))
        chargingLabel = UILabel()
        chargingLabel.backgroundColor = UIColor.groupTableViewBackground
        chargingLabel.layer.cornerRadius = 10
        chargingLabel.clipsToBounds = true
        chargingLabel.textColor = UIColor(r: 152, g: 147, b: 130)
        chargingLabel.text = "计费说明：1小时/1元"
        chargingLabel.font = UIFont.systemFont(ofSize: 16)
        chargingLabel.textAlignment = .center
        
        inputTextField = UITextField()
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
        
        resultLabel = UILabel()
        resultLabel.backgroundColor = UIColor.white
        resultLabel.textAlignment = .center
        
        descripLabel = UILabel()
        descripLabel.font = UIFont.systemFont(ofSize: 14)
        descripLabel.textColor = UIColor(r: 152, g: 147, b: 130)
        descripLabel.text = "输入车牌号，获取解码锁"
        
        self.addSubview(imageV)
        self.addSubview(chargingLabel)
        self.addSubview(inputTextField)
        self.addSubview(sureBtn)
        self.addSubview(resultLabel)
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
            make.width.equalTo(200)
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
        resultLabel.snp.makeConstraints { (make) in
            make.top.equalTo(inputTextField)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(sureBtn)
        }
        descripLabel.snp.makeConstraints { (make) in
            make.top.equalTo(inputTextField.snp.bottom).offset(MGGloabalMargin)
            make.centerX.equalToSuperview()
        }
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(descripLabel).offset(10)
        }
    }
    
    @objc fileprivate func sureBtnClick(_ btn: UIButton) {
        if sureBtnBlock != nil {
            sureBtnBlock!()
        }
    }
    
    // MARK: - UITextFieldDelegate,APNumberPadDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // guard let text = textField.text else { return true }
        let textLength = range.location + string.characters.count
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
