//
//  UpdateTool.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 17/3/22.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import MBProgressHUD

class UpdateTool: NSObject {
    static let share = UpdateTool()
    func checkUpdate() {
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        NetWorkTools.requestData(type: .get, urlString: "http://api.i-techsys.com:7125/ReportService/Version", succeed: { (result, err) in
//            let hud = MBProgressHUD.showAdded(to: MGKeyWindow!, animated: true)
//            hud?.mode = .indeterminate // indeterminate annularDeterminate
//            hud?.labelText = "检查更新"
//            hud?.hide(true)
            guard let serVersion = result as? String else { return }
            if currentVersion == serVersion {
                debugPrint("已是最新版本")
            }else{  // 去下载
                let _ = UIAlertView(title: "App已经优化", message: "", cancleTitle: "取消", otherButtonTitle: ["升级"], onDismissBlock: { (index) in
                        self.jumpToAppStoreDownload()
                    }, onCancleBlock: {
                        debugPrint("取消")
                })
            }
        }) { (err) in
            self.showInfo(info: "网络出错")
        }
    }
    
    func jumpToAppStoreDownload() {
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appid)")  else {  return  }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
//        if #available(iOS 10.0, *) { // UIApplicationOpenURLOptionsKey UIApplicationOpenSettingsURLString
//            if  UIApplication.shared.canOpenURL(url) {
//                let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
//                UIApplication.shared.open(url, options: options, completionHandler: nil)
//                    UIApplication.shared.open(url, options: options, completionHandler: { (_) in
//                })
//            }
//            
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.openURL(url)
//            }
//            
//        }else {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.openURL(url)
//            }
//        }
    }
}
