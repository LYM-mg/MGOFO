//
//  ScanBottomView.swift
//  MGDYZB
//
//  Created by i-Techsys.com on 17/4/11.
//  Copyright © 2017年 ming. All rights reserved.
//

import UIKit

enum MGButtonType: Int {
    case photo, flash, myqrcode,intput
}

class ScanBottomView: UIView {
    fileprivate lazy var myButtons: [UIButton] = [UIButton]()
    var btnClickBlcok: ((_ view: ScanBottomView,_ btn: UIButton, _ type: MGButtonType)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkGray
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension ScanBottomView {
    func setUpUI() {
        // 设置UI
        let btn1 = setUpBtn(image: UIImage(named: "inputBlikeNo_90x91_")!, highlightedImage: #imageLiteral(resourceName: "inputBlikeNo_90x91_"), title: "手动输入车牌号",type: .intput)
        let flashBtn = setUpBtn(image: UIImage(named: "btn_unenableTorch_45x45_")!, highlightedImage: UIImage(named: "btn_enableTorch_45x45_")!, title: "手电筒",type: .flash)
        
        // 布局UI
        let margin: CGFloat = 35
        let count: CGFloat = CGFloat(myButtons.count)
        let width = (self.frame.width - margin*CGFloat(count+1))/count
        let height = self.frame.height - margin*1
        let y: CGFloat = 15
        
        let x = margin
        btn1.frame = CGRect(x: x, y: y, width: width, height: height)

        flashBtn.frame = CGRect(x: MGScreenW - width - margin, y: y, width: width, height: height)
        /*
        for (i,btn) in myButtons.enumerated() {
            let x = CGFloat(i)*width + margin
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        */
    }
    
    func setUpBtn(image: UIImage,highlightedImage: UIImage,title: String,type: MGButtonType) -> UIButton{
        let btn = MoreButton(image: image, highlightedImage: highlightedImage,title: title, target: self, action: #selector(self.btnClick(btn:)))
        btn.tag = type.rawValue
        self.addSubview(btn)
        myButtons.append(btn)
        return btn
    }
    
    @objc func btnClick(btn: UIButton) {
        switch btn.tag {
            case 0:
                btn.isSelected = !btn.isSelected
            case 1:
                btn.isSelected = !btn.isSelected
            case 2:
                btn.isSelected = !btn.isSelected
            default: break
        }
       
        if self.btnClickBlcok != nil {
            btnClickBlcok!(self,btn,MGButtonType(rawValue: btn.tag)!)
        }
    }
}
