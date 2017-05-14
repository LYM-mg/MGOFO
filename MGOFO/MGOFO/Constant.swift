//
//  Constant.swift
//  chart2
//
//  Created by i-Techsys.com on 16/11/24.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

// MARK:- 全局参数
let appid = "1226331064"
let MGScreenBounds = UIScreen.main.bounds
let MGScreenW      = UIScreen.main.bounds.size.width
let MGScreenH      = UIScreen.main.bounds.size.height

/// 状态栏高度20
let statusHeight: CGFloat = 20
/// 导航栏高度64
let navHeight: CGFloat = 64
/// tabBar的高度 50
let tabBarHeight: CGFloat = 50
/// 全局的间距 10
let MGGloabalMargin: CGFloat = 10
/** 导航栏颜色 */
let navBarTintColor  = UIColor.colorWithCustom(r: 83, g: 179, b: 163)

/** 全局字体 */
let MG_FONT = "Bauhaus ITC"

// 全局存储的key
/// 存储登录用户信息的路径
let MGUserPath: String = "user.plist".cache()
/// 存储登录用户信息
let MGUserInfoKey: String = "MGUserInfoKey"

/// 是否登录
let isLoginKey: String = "isLoginKey"

let MGGetCompanysKey: String = "MGGetCompanysKey"
/// 记录服务器IP
let MGServeraddressKey = "MGServeraddressKey"
/// 搜索数组的key
let MGSearchViewControllerHistorySearchArray = "MGSearchViewControllerHistorySearchArray"



/// 主窗口代理
let KAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

// iOS在当前屏幕获取第一响应
let MGKeyWindow = UIApplication.shared.keyWindow
let MGFirstResponder = MGKeyWindow?.perform(Selector(("firstResponder")))



// MARK:- 通知
/// 通知中心
let MGNotificationCenter = NotificationCenter.default

/// 首页设置按钮的点击
let MGSideTableViewCellClickNoti  = "MGSideTableViewCellClickNoti"
/// 首页选中公司后的通知
let MGSelectCompanyClickNoti  = "MGSelectCompanyClickNoti"
/** 通知：头部即将消失的的通知 */
let MGWillDisplayHeaderViewNotification = "MGWillDisplayHeaderViewNotification"
/** 通知：头部完全消失的的通知 */
let MGDidEndDisplayingHeaderViewNotification = "MGDidEndDisplayingHeaderViewNotification"

/// 搜索历史记录的点击
let MGSelectHistoryearchClickNoti  = "MGSelectHistoryearchClickNoti"


