//
//  UserHeaderView.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/9.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class UserHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - 设置UI和布局
extension UserHeaderView {
    fileprivate func setUpUI() {
        // 创建子控件
        let iconV = UIImageView(image: #imageLiteral(resourceName: "UserInfo_defaultIcon_120x120_"))
        let name = UILabel()
        name.text = "OFO"
        let certificationV = UIImageView(image: #imageLiteral(resourceName: "GrayCerTification_homePage_13x9_"))
        let certification = UILabel()
        certification.text = "未认证"
        let credit = UILabel()
        credit.text = "信用：100"
        let seperateView = UIView()
        seperateView.backgroundColor = UIColor.lightGray
        
        addSubview(iconV)
        addSubview(name)
        addSubview(certificationV)
        addSubview(certification)
        addSubview(credit)
        addSubview(seperateView)
        
        // 2.布局子控件
        iconV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(iconV.snp.width)
        }
        name.snp.makeConstraints { (make) in
            make.top.equalTo(iconV.snp.top)
            make.left.equalTo(iconV.snp.right).offset(8)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(certificationV.snp.top).offset(-3)
        }
        certificationV.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconV)
            make.left.equalTo(name)
            make.height.width.equalTo(25)
        }
        certification.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconV)
            make.left.equalTo(certificationV.snp.right).offset(5)
        }
        credit.snp.makeConstraints { (make) in
            make.top.equalTo(certificationV.snp.bottom).offset(3)
            make.left.equalTo(name)
            make.bottom.equalTo(iconV)
        }
        seperateView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
