//
//  AppDelegate.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/9.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//  7728ab18dd2abf89a6299740e270f4c6

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setUpKeyWindow()
        
        setUpAllThird()
        
        return true
    }
    
    fileprivate func setUpKeyWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        let homeVc = HomeViewController()
        let sideVc = SideViewController()
        let homeNav = BaseNavigationController(rootViewController: homeVc)
        let sideNav = BaseNavigationController(rootViewController: sideVc)
        let revealController = SWRevealViewController(rearViewController: sideNav, frontViewController: homeNav)
        revealController?.delegate = self
        
        self.window?.rootViewController = revealController
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: SWRevealViewControllerDelegate {
    @nonobjc func revealController(_ revealController: SWRevealViewController, animationControllerFor operation: SWRevealControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> Any? {
        if operation != SWRevealControllerOperationReplaceRightController {
            return nil
        }
        return nil
    }
}

extension AppDelegate {
    fileprivate func setUpAllThird() {
        // 注册高德地图以及设置支持https
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = "7728ab18dd2abf89a6299740e270f4c6"
    }
}

