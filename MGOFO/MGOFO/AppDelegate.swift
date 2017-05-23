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
    //后台任务
    var backgroundTask:UIBackgroundTaskIdentifier! = nil

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
        let revealController = SWRevealViewController(rearViewController: sideVc, frontViewController: homeNav)
        revealController?.delegate = self
        
        self.window?.rootViewController = revealController
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        
        //如果要后台运行
        //注册后台任务
        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
            () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        })
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

