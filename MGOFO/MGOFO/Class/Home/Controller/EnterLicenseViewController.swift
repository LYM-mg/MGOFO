//
//  EnterLicenseViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class EnterLicenseViewController: UIViewController { // 容器控制器
    var i = 0
    weak var currentViewController: UIViewController! // 容器视图
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = ManuallyEnterLicenseVC()
        vc1.superVC = self
        let nav1 = UINavigationController(rootViewController: vc1)
        addChildViewController(nav1)
        let vc2 = GetLicensePlateNumberVC()
        vc2.superVC = self
        vc2.view.backgroundColor = UIColor.green
        let nav2 = UINavigationController(rootViewController: vc2)
        addChildViewController(nav2)
        
        // 需要显示的子ViewController，要将其View添加到父View中
        currentViewController = nav1
        view.addSubview(nav1.view)
        view.addSubview(nav2.view)
        view.addSubview(currentViewController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let firstController: UIViewController? = childViewControllers[0]
//        let secondController: UIViewController? = childViewControllers[1]
//        let oldController: UIViewController? = currentViewController
//        
//        
//        i += 1
//        if i % 2 == 0 {
//            transition(from: currentViewController, to: secondController!, duration: 1, options: .transitionFlipFromLeft, animations: {() -> Void in
//            }, completion: {(_ finished: Bool) -> Void in
//                if finished {
//                    self.currentViewController = secondController
//                    self.view.addSubview(self.currentViewController.view)
//                }
//                else {
//                    self.currentViewController = oldController
//                }
//            })
//        }
//        else {
//            transition(from: currentViewController, to: firstController!, duration: 1, options: .transitionFlipFromRight, animations: {() -> Void in
//            }, completion: {(_ finished: Bool) -> Void in
//                if finished {
//                    self.currentViewController = firstController
//                    self.view.addSubview(self.currentViewController.view)
//                }
//                else {
//                    self.currentViewController = oldController
//                }
//            })
//        }
//    }
}
