//
//  Get 车牌 plate number; licence plate; 车牌号 名 plate number; 车牌号码 名 license plate; GetLicensePlateViewController 车牌号 GetLicensePlateNumber.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class GetLicensePlateNumberVC: UIViewController {

    weak var superVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "车辆解锁"
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "如何开锁", style: .done, target: self, action: #selector(helpUnlock))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationButtonReturnClick"), highImage: #imageLiteral(resourceName: "navigationButtonReturnClick"), norColor: UIColor.darkGray, selColor: UIColor.lightGray, title: "返回", target: self, action: #selector(GetLicensePlateNumberVC.popClick(_:)))
        // setUpMainView()
    }
    
    @objc fileprivate func popClick(_ sender: UIButton) {
        let _ = superVC?.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func helpUnlock() {
        let _ = superVC?.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
