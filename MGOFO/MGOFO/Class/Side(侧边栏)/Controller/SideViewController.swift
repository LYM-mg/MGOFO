//
//  ViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/9.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import SnapKit

class SideViewController: UIViewController {
    
    fileprivate lazy var userView: UserHeaderView = UserHeaderView()
    fileprivate lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.dataSource = self
        tb.delegate = self
        
        let img = UIImageView(image: #imageLiteral(resourceName: "RedPacketBike_340x135_"))
        img.frame = CGRect(x: 0, y: 1, width: MGScreenW*0.82, height: 110)
        let footerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: MGScreenW*0.82, height: 111)))
        footerView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        footerView.addSubview(img)
        tb.tableFooterView = footerView
        return tb
    }()
    fileprivate lazy var dataArr = [[String : Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        setUpMainView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.mg_width = MGScreenW*0.82
    }
}

// MARK: - 设置UI布局
extension SideViewController {
    fileprivate func setUpMainView() {
        self.view.addSubview(userView)
        self.view.addSubview(tableView)
        
        if tableView.responds(to:#selector(setter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        if tableView.responds(to:#selector(setter: UIView.layoutMargins)) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        
        userView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(110)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(userView.snp.bottom).offset(2)
            make.bottom.left.right.equalToSuperview()
        }
        loadData()
    }
    
    fileprivate func loadData() {
        guard let path = Bundle.main.path(forResource: "SideData.plist", ofType: nil) else { return  }
        guard let arr = NSArray(contentsOfFile: path) as? [[String : Any]] else { return }
        
        for dict in arr {
            dataArr.append(dict)
        }
        
        tableView.reloadData()
    }
}


// MARK: - 设置UI布局
extension SideViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "KUserCellID")
    
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "KUserCellID")
        }
        // 这个判断selected，设置子试图颜色状态
        let bgView = UIView()
        bgView.backgroundColor = UIColor.brown.withAlphaComponent(0.7) // 蓝色太难看了，设置为棕色
        cell!.selectedBackgroundView = bgView
        cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        // 设置数据
        let model = self.dataArr[indexPath.row]
        cell!.textLabel?.text = model["title"] as? String
        cell!.detailTextLabel?.text = (indexPath.row == 1) ? "100元" : ""
        cell!.imageView?.image = UIImage(named: model["imageName"] as! String)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MGNotificationCenter.post(name: NSNotification.Name(MGSideTableViewCellClickNoti), object: nil, userInfo: ["row": indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to:#selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
}
