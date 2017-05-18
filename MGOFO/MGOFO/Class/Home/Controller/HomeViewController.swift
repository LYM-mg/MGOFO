//
//  HomeViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/10.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import FTIndicator

class HomeViewController: UIViewController {
    
    // AMRK: - 地图
    fileprivate lazy var mapView: MAMapView = MAMapView()
    fileprivate lazy var carPanelView: CarPanelView = CarPanelView()
    fileprivate lazy var search: AMapSearchAPI = AMapSearchAPI()
    fileprivate lazy var  annotations: [MAPointAnnotation] = [MAPointAnnotation]()
    fileprivate lazy var  myPin: MyPinAnnotation = MyPinAnnotation()
    fileprivate lazy var  myPinView: MAPinAnnotationView = MAPinAnnotationView()
    var isNearBySearch: Bool = true
    fileprivate lazy var walkManager: AMapNaviWalkManager = AMapNaviWalkManager() // 走路路线管理者
    fileprivate lazy var bgView: UIView = {
        let v = UIView(frame: MGScreenBounds)
        v.backgroundColor = UIColor(r: 200, g: 200, b: 200, a: 0.8)
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.leftClick)))
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        #if TARGET_IPHONE_SIMULATOR//模拟器
            self.showInfo(info: "相机不可用")
        #elseif TARGET_OS_IPHONE//真机
            self.showInfo(info: "真机设备")
        #endif

        setUpMainView()
        setUpNavgationItem()
        setUpNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        print("HomeViewController == deinit")
        MGNotificationCenter.removeObserver(self)
    }
}

// MARK: - 初始化
extension HomeViewController {
    // MARK: 导航栏Navigation
    fileprivate func setUpNavgationItem() {
        //let
        let revealController = self.getRevealViewController()
        revealController.rearViewRevealWidth = MGScreenW*0.82
        view.addGestureRecognizer(revealController.panGestureRecognizer())
        view.addGestureRecognizer(revealController.tapGestureRecognizer())
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "leftTopImage_20x20_").withRenderingMode(.alwaysOriginal), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ofoLogo_83x18_"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "rightTopImage_20x20_").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(HomeViewController.hotSportClick))
        
        MGNotificationCenter.addObserver(self, selector: #selector(self.mgLeftClickNoti(_:)), name: NSNotification.Name.init("MGLeftClickNoti"), object: nil)
    }
    
    // 热门活动
    @objc fileprivate func hotSportClick() {  // http://m.ofo.so/active.html
        self.show(WKWebViewController(navigationTitle: "活动中心", urlStr: "https://common.ofo.so/newdist/?Campaigns&app_id=2017030406052783&source=alipay_wallet&scope=auth_base&auth_code=2173b5cb27e64fb08bc1bc124faeUX34"), sender: nil)
    }
    
    @objc fileprivate func leftClick() {
        self.revealViewController().revealToggle(nil)
    }
    
    @objc func mgLeftClickNoti(_ noti: Notification) {
        if  self.revealViewController().frontViewPosition == .left {
            self.bgView.removeFromSuperview()
        }else {
            self.view.addSubview(self.bgView)
        }
    }
    
    // MARK: setUpMainView
    fileprivate func setUpMainView() {
        view.addSubview(mapView)
        view.addSubview(carPanelView)
        
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        carPanelView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        carPanelView.delegate = self
        mapView.zoomLevel = 17
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
        search.delegate = self
        walkManager.delegate = self
    }
    
    // MARK: 通知Notification
    fileprivate func setUpNotification() {
        MGNotificationCenter.addObserver(self, selector: #selector(self.sideTableViewCellClick(_:)), name: NSNotification.Name(MGSideTableViewCellClickNoti), object: nil)
        MGNotificationCenter.addObserver(self, selector: #selector(self.sideUserViewClick(_:)), name: NSNotification.Name(MGSideUserViewClickNoti), object: nil)
        MGNotificationCenter.addObserver(self, selector: #selector(self.sideFooterViewClick(_:)), name: NSNotification.Name(MGSideFooterViewClickClickNoti), object: nil)
    }
    
    @objc fileprivate func sideTableViewCellClick(_ noti: NSNotification) {
        guard let row: Int = noti.userInfo?["row"] as? Int else { return }
        
        switch row {
            case 0:
                self.show(WKWebViewController(navigationTitle: "我的行程", urlStr: "https://common.ofo.so/newdist/?MeineReise&time=1494867448705"), sender: nil)
                break
            case 1:
                show(MyWalletViewController(nibName: "MyWalletViewController", bundle: nil), sender: nil)
            case 2:
                self.show(WKWebViewController(navigationTitle: "有码加入", urlStr: "https://common.ofo.so/newdist/?Redeem&time=1494867448705"), sender: nil)
                break
            case 3: // https://scofo.ofo.so:8443
                self.show(WKWebViewController(navigationTitle: "邀请好友", urlStr: "https://common.ofo.so/newdist/?CampaignDetail&app_id=2017030406052783&source=alipay_wallet&scope=auth_base&auth_code=2173b5cb27e64fb08bc1bc124faeUX34&~url=%22https%3A%2F%2Fcommon.ofo.so%2Fcampaign%2F17-2-21%2F%3Futm_source%3Dapp_activity%26utm_medium%3Dpopup%26utm_campaign%3D798_1494837726422%22"), sender: nil)
                break
            case 4:  // http://www.jianshu.com/u/57b58a39b70e
                self.show(WKWebViewController(navigationTitle: "使用指南", urlStr: "https://common.ofo.so/about/help.html"), sender: nil)
                break
            case 5:
                show(AboutUsViewController(), sender: nil)
                break
            default:
                break
        }
        leftClick()
    }
    
    @objc fileprivate func sideUserViewClick(_ noti: Notification) {
        leftClick()
        self.show(WKWebViewController(navigationTitle: "我", urlStr: "https://common.ofo.so/newdist/?MeineReise&time=1494867448705"), sender: nil)
    }
    @objc fileprivate func sideFooterViewClick(_ noti: Notification) {
        leftClick()
        self.show(WKWebViewController(navigationTitle: "我", urlStr: "http://m.ofo.so/active.html"), sender: nil)
    }
}

// MARK: - 搜索🔍
extension HomeViewController: AMapSearchDelegate {
    fileprivate func searchNearBy() {
        isNearBySearch = true
        searchCustomLocationNearBy(mapView.userLocation.coordinate)
    }
    fileprivate func searchCustomLocationNearBy(_ center: CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        // "汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施"
        request.keywords = "餐馆"
        request.radius = 500
        request.requireExtension = true
        
        search.aMapPOIAroundSearch(request)
    }
    
    // 搜索周边完成后的出处理
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        mapView.removeAnnotation(myPin)
        annotations.removeAll() // 删除之前搜索到的数据
        guard response.count > 0 else {
            self.showHint(hint: "没有获取到小黄车", imageName: "treasure_finish_46x46_")
            return
        }
        
        self.annotations = response.pois.map {
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            
            if $0.distance < 200 {
                annotation.title = "红包区域内开锁小黄车"
                annotation.subtitle = "骑行10分钟可以获得现金红包"
            }else {
                annotation.title = "正常可用"
                annotation.subtitle = "立即解锁骑行小黄车"
            }
            return annotation
        }
        mapView.addAnnotations(annotations)
        
        if isNearBySearch {
            isNearBySearch = !isNearBySearch
            // mapView.showAnnotations(annotations, animated: true)
        }
        mapView.addAnnotation(myPin)
        mapView.bringSubview(toFront: self.myPinView)
    }
}

// MARK: - MAMapViewDelegate
extension HomeViewController: MAMapViewDelegate {
    /// 地图初始化完成之后调用,主要设置这个用户始终显示在屏幕中心
    /// - Parameter mapView: 地图
    func mapInitComplete(_ mapView: MAMapView!) {
        searchNearBy()
        myPin.coordinate = mapView.centerCoordinate
        myPin.lockedScreenPoint = CGPoint(x: MGScreenW/2, y: MGScreenH/2)
        myPin.isLockedToScreen = true
        
        mapView.addAnnotation(myPin)
        mapView.showAnnotations([myPin], animated: true)
    }
    
    /// 用户移动地图的交互
    /// - Parameters:
    ///   - mapView: 地图
    ///   - wasUserAction: 是否是用户操作
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction {
            let endFrame = myPinView.frame
            myPinView.frame = endFrame.offsetBy(dx: 0, dy: -80)
            
            searchCustomLocationNearBy(mapView.centerCoordinate)
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.myPinView.frame = endFrame
            }, completion: nil)
        }
    }
    
    func mapView(_ mapView: MAMapView!, mapWillMoveByUser wasUserAction: Bool) {
        mapView.bringSubview(toFront: self.myPinView)
    }
    
    // 选中大头针的时候调用 路线规划
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        let start = myPin.coordinate
        let end = view.annotation.coordinate
        guard let startP = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude)) else { return }
        guard let endP = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude)) else { return }
        walkManager.calculateWalkRoute(withStart: [startP], end: [endP])
        myPin.isLockedToScreen = false
        mapView.showsScale = true
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline {
            guard let polylineRenderer = MAPolylineRenderer(overlay: overlay) else { return nil }
            mapView.visibleMapRect = overlay.boundingMapRect
            polylineRenderer.lineWidth = 8
            polylineRenderer.fillColor = UIColor.green
            polylineRenderer.lineJoinType = kMALineJoinRound
            polylineRenderer.lineCapType = kMALineCapRound
            
            // 设置纹理 3D才可用
            polylineRenderer.loadStrokeTextureImage(#imageLiteral(resourceName: "nextArrow_unenable_25x19_"))
            return polylineRenderer
        }
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        mapView.removeOverlays(mapView.overlays)
        myPin.isLockedToScreen = true
    }
    
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]
        
        for aView in aViews {
            guard !(aView.annotation is MyPinAnnotation) else {
                continue
            }
            aView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                aView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    aView.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    /// 自定义大头针
    /// - Parameters:
    ///   - mapView: 地图
    ///   - annotation: 大头针
    /// - Returns: MAAnnotationView大头针View
    @objc(mapView:viewForAnnotation:) func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAUserLocation {
            return nil
        }
        
        // 自定义在屏幕中心的点
        if annotation is MyPinAnnotation {
            let kMyPinId = "kMyPinId"
            var an = mapView.dequeueReusableAnnotationView(withIdentifier: kMyPinId)
            if an == nil {
                an = MAPinAnnotationView(annotation: annotation, reuseIdentifier: kMyPinId)
            }
            an?.image = #imageLiteral(resourceName: "homePage_wholeAnchor_24x37_")
            an?.canShowCallout = true
            myPinView = an as! MAPinAnnotationView
            return an
        }
        
        if annotation is MAPointAnnotation {
            // 创建MAPointAnnotation并且循环利用
            let kPointReuseIndetifier = "kPointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: kPointReuseIndetifier) as! MAPinAnnotationView?
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: kPointReuseIndetifier)
            }
            
            if annotation.title == "正常可用" {
                annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike_50x50_")
                 annotationView?.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "adoptBikeICON_50x50_"))
            } else {
                annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket_55x59_")
                 annotationView?.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "HomePage_repotyTypeOne_60x60_"))
            }
           
            annotationView!.canShowCallout = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            return annotationView!
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        
    }
}

// MARK: - 用车面板CarPanelViewDelegate
extension HomeViewController: AMapNaviWalkManagerDelegate {
    func walkManager(onArrivedDestination walkManager: AMapNaviWalkManager) {
        self.showHint(hint: "到达目的地")
    }
    func walkManager(_ walkManager: AMapNaviWalkManager, error: Error) {
        self.showHint(hint: "没有可以路线")
    }
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        self.showHint(hint: "规划路线成功", mode: .indeterminate)
        mapView.removeOverlays(mapView.overlays)
        var coordinates: [CLLocationCoordinate2D] = (walkManager.naviRoute?.routeCoordinates!.map {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
            })!
        
        let polyline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.add(polyline)
        
        // 提示用时和距离
        let walkMinute = walkManager.naviRoute!.routeTime / 60
        let distance = walkManager.naviRoute!.routeLength
        var walkMinuteTip = "一分钟以内"
        var distanceTip = "距离\(distance)" + "米"
        if walkMinute > 0 {
            walkMinuteTip = "\(walkMinute)" + "分钟"
        }
        if distance > 1000 {
            distanceTip = "距离" + String(format: "%.2f", Float(distance)/1000.0)  + "km"
        }
        
        FTIndicator.setIndicatorStyle(.light)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock_24x24_"), title: walkMinuteTip, message: distanceTip)
    }
}

// MARK: - 用车面板CarPanelViewDelegate
extension HomeViewController: CarPanelViewDelegate {
    /**
     * btn: UIButton,点击的按钮
     * view: CarPanelView
     */
    func carPanelViewUpdateLocationBlock(_ view: CarPanelView, _ btn: UIButton) {
        searchNearBy()
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }

    func carPanelViewInstantUserCarClickBlock(_ view: CarPanelView, _ btn: UIButton) {
        // self.showHint(hint: "立即用车")
        self.show(MGScanViewController(), sender: nil)
    }

    func carPanelViewSuggestClickBlock(_ view: CarPanelView, _ btn: UIButton) {
        self.show(WKWebViewController(navigationTitle: "吐槽", urlStr: "https://common.ofo.so/newdist/?Prosecute&time=1494868261998"), sender: nil)
    }
}
