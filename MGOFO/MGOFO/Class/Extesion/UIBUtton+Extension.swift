//
//  UIBUtton+Extension.swift
//  chart2
//
//  Created by i-Techsys.com on 16/12/7.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

extension UIButton {
    /// 遍历构造函数
    convenience init(image:UIImage?, bgImage:UIImage?,target: Any!, action:Selector!){
        self.init()
        
        // 1.设置按钮的属性
        // 1.1图片
        if let image = image {
            setImage(image, for: .normal)
        }
        
        // 1.2背景
        if let bgImage = bgImage {
            setBackgroundImage(bgImage, for: .normal)
        }
        
        // 2.设置尺寸
        sizeToFit()
        
        // 3.监听
        if target != nil {            
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    convenience init(bgImage: UIImage?,title: String,target: Any, action:Selector) {
        self.init()
        // 1.2背景
        if let bgImage = bgImage {
            setBackgroundImage(bgImage, for: .normal)
        }
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 50
        setTitle(title, for: UIControlState.normal)
        setTitleColor(UIColor.orange, for: UIControlState.normal)
        // 3.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(image:UIImage,highlightedImage: UIImage?,title: String, target: Any, action:Selector) {
        self.init()
        // 1.设置按钮的属性
        setImage(image, for: .normal)
        if highlightedImage != nil {
            setImage(highlightedImage, for: .highlighted)
        }
        setTitle(title, for: UIControlState.normal)
        setTitleColor(UIColor.orange, for: UIControlState.normal)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(image:UIImage,selectedImage: UIImage?, target: Any, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(image, for: .normal)
        if selectedImage != nil {
            setImage(selectedImage, for: .selected)
        }
        setTitle("", for: UIControlState.normal)
        
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }


    
    // MARK: - 👆上面是项目使用到的方法
    convenience init(imageName:String, target: Any, action:Selector) {
        self.init()
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), for: .normal)
//        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(title:String, target: Any, action:Selector) {
        self.init()
        setTitle(title, for: UIControlState.normal)
        sizeToFit()
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(imageName:String, title: String, target: Any, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), for: .normal)
//        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setTitle(title, for: UIControlState.normal)
        showsTouchWhenHighlighted = true
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }

    convenience init(image: UIImage, title: String, target:Any, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(image, for: .normal)
        //        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setTitle(title, for: UIControlState.normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(.lightGray, for: .highlighted)
        showsTouchWhenHighlighted = true
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
}
