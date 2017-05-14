//  CarPanelView.swift
//  MGOFO
//  用车界面View

import UIKit

@objc protocol CarPanelViewDelegate: NSObjectProtocol {
    /**
     * btn: UIButton,点击的按钮
     * view: CarPanelView
     */
    func carPanelViewUpdateLocationBlock(_ view: CarPanelView,_ btn: UIButton)
    func carPanelViewInstantUserCarClickBlock(_ view: CarPanelView,_ btn: UIButton)
    func carPanelViewSuggestClickBlock(_ view: CarPanelView,_ btn: UIButton)
}

class CarPanelView: UIView {
    weak var delegate: CarPanelViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI和布局
extension CarPanelView {

    fileprivate func setUpUI() {
        // 定位
        let locationBtn = UIButton(image: #imageLiteral(resourceName: "leftBottomImage_60x60_"), bgImage: #imageLiteral(resourceName: "leftBottomBackgroundImage_60x60_"), target: self, action: #selector(CarPanelView.updateLocation(_:)))
    
        let locationDes = bulidLabel(text: "定位")
        
        // 用车按钮
        let userCarBtn = UIButton(bgImage: #imageLiteral(resourceName: "userBikeImage_100x100_"), title: "立即用车", target: self, action: #selector(CarPanelView.instantUserCar(_:)))
        
        // 吐槽
        let suggestBtn = UIButton(image: #imageLiteral(resourceName: "rightBottomImage_60x60_"), bgImage:#imageLiteral(resourceName: "HomePage_rightBottomBackground_60x60_"), target: self, action: #selector(CarPanelView.suggestClick(_:)))
        let suggestDes = bulidLabel(text: "吐槽")

        addSubview(locationBtn)
        addSubview(locationDes)
        addSubview(userCarBtn)
        addSubview(suggestBtn)
        addSubview(suggestDes)
        
        // 2.布局子控件
        userCarBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(100)
            make.center.equalToSuperview()
        }
        locationBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(userCarBtn).offset(-5)
            make.right.equalTo(userCarBtn.snp.left).offset(-30)
            make.height.width.equalTo(60)
        }
        locationDes.snp.makeConstraints { (make) in
            make.centerX.equalTo(locationBtn)
            make.top.equalTo(locationBtn.snp.bottom).offset(-2)
            make.height.equalTo(25)
        }
        suggestBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(userCarBtn).offset(-5)
            make.left.equalTo(userCarBtn.snp.right).offset(30)
            make.height.width.equalTo(locationBtn)
        }
        suggestDes.snp.makeConstraints { (make) in
            make.centerX.equalTo(suggestBtn)
            make.height.equalTo(locationDes)
            make.top.equalTo(suggestBtn.snp.bottom).offset(-2)
        }
    }
    
    // 定位
    @objc fileprivate func updateLocation(_ btn: UIButton) {
        if delegate != nil && (delegate?.responds(to: #selector(CarPanelViewDelegate.carPanelViewUpdateLocationBlock(_:_:))))! {
            delegate?.carPanelViewUpdateLocationBlock(self, btn)
        }
    }
    // 吐槽
    @objc fileprivate func suggestClick(_ btn: UIButton) {
        if delegate != nil && (delegate?.responds(to: #selector(CarPanelViewDelegate.carPanelViewSuggestClickBlock(_:_:))))! {
            delegate?.carPanelViewSuggestClickBlock(self, btn)
        }
    }
    // 立即用车
    @objc fileprivate func instantUserCar(_ btn: UIButton) {
        if delegate != nil && (delegate?.responds(to: #selector(CarPanelViewDelegate.carPanelViewInstantUserCarClickBlock(_:_:))))! {
            delegate?.carPanelViewInstantUserCarClickBlock(self, btn)
        }
    }
    
    fileprivate func bulidLabel(text: String) -> UILabel {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.text = text
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }
}
