//
//  BaseNavigationController.swift
//  chart2
//
//  Created by i-Techsys.com on 16/12/7.
//  Copyright © 2016年 i-Techsys. All rights reserved.
// 83 179 163

import UIKit

// MARK: - 生命周期
class BaseNavigationController: UINavigationController {
    
    var popDelegate: UIGestureRecognizerDelegate?
    lazy var popBtn: UIButton = {
        let popBtn = UIButton(image: #imageLiteral(resourceName: "navigationButtonReturnClick"), title: "返回", target: self, action: #selector(BaseNavigationController.popClick(_:)))
        // 设置popBtn的属性
        //        popBtn.mg_size = CGSize(width: 60, height: 20)
        popBtn.setTitleColor(UIColor.white, for: .normal)
        popBtn.setTitleColor(UIColor.colorWithCustom(r: 60, g: 60, b: 60), for: .highlighted)
        
        popBtn.contentHorizontalAlignment = .left
        popBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        popBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        popBtn.titleEdgeInsets  = UIEdgeInsetsMake(0, 0, 0, 0)
        return popBtn
    }()

    
    override class func initialize() {
        super.initialize()
        // 0.设置导航栏的颜色
        setUpNavAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.全局拖拽手势
        setUpGlobalPanGes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - 拦截控制器的push操作
extension BaseNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if self.childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: popBtn)
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationButtonReturnClick"), highImage: #imageLiteral(resourceName: "navigationButtonReturnClick"), norColor: UIColor.darkGray, selColor: UIColor.lightGray, title: "返回", target: self, action: #selector(BaseNavigationController.popClick(_:)))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func popClick(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
    // 回到栈顶控制器
    public func popToRootVC() {
        popToRootViewController(animated: true)
    }
}

// MARK: - 全局拖拽手势
extension BaseNavigationController: UIGestureRecognizerDelegate {
    /// 全局拖拽手势
    func setUpGlobalPanGes() {
        // 1.创建Pan手势
        let target = interactivePopGestureRecognizer?.delegate
        let globalPan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        globalPan.delegate = self
        self.view.addGestureRecognizer(globalPan)
        
        // 2.禁止系统的手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    /// 什么时候支持全屏手势（解决手势和TableView左滑冲突问题）
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count != 1 {
            if (gestureRecognizer is UIPanGestureRecognizer) {
                if (self.topViewController != nil) && (self.view.gestureRecognizers!.contains(gestureRecognizer)) {
                    let tPoint: CGPoint = ((gestureRecognizer as? UIPanGestureRecognizer)?.translation(in: gestureRecognizer.view))!
                    if tPoint.x >= 0 {
                        let y: CGFloat = fabs(tPoint.y)
                        let x: CGFloat = fabs(tPoint.x)
                        let af: CGFloat = 30.0 / 180.0 * .pi  // tanf(Float(af))
                        let tf: CGFloat = tan(af)
                        return (y / x) <= tf
                    } else {
                        return false
                    }
                }
            }
            return true
        } else {
           return false
        }
    }
    
    /// 移除全局手势
    func removeGlobalPanGes() {
//        for ges in self.view.gestureRecognizers! where ges is UIPanGestureRecognizer {
//            print(ges)
//            self.view.gestureRecognizers?.remove(at: 1)
//        }
        for case let ges as UIPanGestureRecognizer in self.view.gestureRecognizers! {
            let i = self.view.gestureRecognizers?.index(of: ges)
            self.view.gestureRecognizers?.remove(at: i!)
            print(ges)
        }
    }
}

// MARK: - 设置导航栏肤色
extension BaseNavigationController {
    fileprivate class func setUpNavAppearance() {
        // ======================  bar ======================
        var navBarAppearance = UINavigationBar.appearance()
        if #available(iOS 9.0, *) {
           navBarAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [BaseNavigationController.self as UIAppearanceContainer.Type])
        } 

        navBarAppearance.isTranslucent = true
        if #available(iOS 10.0, *) {  // 导航栏透明
            navBarAppearance.isTranslucent = true
        }
        else {
            self.init().navigationBar.isTranslucent = false
        }

        navBarAppearance.tintColor = UIColor(r: 124, g: 116, b: 100)
        var titleTextAttributes = [String : Any]()
        titleTextAttributes[NSForegroundColorAttributeName] =  UIColor(r: 124, g: 116, b: 100)
        titleTextAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 19)
        navBarAppearance.titleTextAttributes = titleTextAttributes
        
        // ======================  item  =======================
        let barItemAppearence = UIBarButtonItem.appearance()
        // 设置导航字体
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 110, green: 110, blue: 110, alpha: 0.8)
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        var attributes = [String : Any]()
        attributes[NSForegroundColorAttributeName] = UIColor(r: 247, g: 215, b: 81)
        attributes[NSShadowAttributeName] = shadow
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 17)
        barItemAppearence.setTitleTextAttributes(attributes, for: .normal)
        
        attributes[NSForegroundColorAttributeName] = UIColor.white
        barItemAppearence.setTitleTextAttributes(attributes, for: .highlighted)
    }
}

