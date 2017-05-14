//
//  AboutUsViewController.swift
//  MGOFO
//
//  Created by i-Techsys.com on 2017/5/11.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    // MARK: - 懒加载属性
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tb = UITableView()
        tb.backgroundColor = UIColor.clear
        tb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tb.dataSource = self
        tb.delegate = self
        tb.rowHeight = 40
        tb.isScrollEnabled = false
        tb.tableFooterView = UIView()
        return tb
    }()
    fileprivate lazy var dataArr = [["title": "微信服务号","detail": "ofobike"],["title": "ofo官网","detail": "www.ofo.so"],["title": "商务合作","detail": "bdinchina@ofo.so"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
        view.backgroundColor = UIColor(r: 246, g: 246, b: 246)
        setUpMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

// MARK: - TableView数据源
extension AboutUsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")
        }
        cell?.textLabel?.textColor = UIColor(r: 152, g: 147, b: 130)
        cell?.detailTextLabel?.textColor = UIColor(r: 152, g: 147, b: 130)
        cell!.textLabel?.text = dataArr[indexPath.row]["title"]
        cell!.detailTextLabel?.text = dataArr[indexPath.row]["detail"]
        return cell!
    }
}

// MARK: - TableView代理
extension AboutUsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        switch indexPath.row {
            case 0:
                // iOS 将内容复制到剪切板
                let pasteboard = UIPasteboard.general
                pasteboard.string = cell?.detailTextLabel?.text
                self.showHint(hint: "已复制到剪贴板")
                break
            case 1:
                self.show(WKWebViewController(navigationTitle: "关于ofo", urlStr: "http://m.ofo.so/index.html"), sender: nil)
            case 2:
                break
            default:
                break
        }
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


// MARK: - Navigation
extension AboutUsViewController {
    // MARK: setUpMainView
    fileprivate func setUpMainView() {
        self.automaticallyAdjustsScrollViewInsets = false
        if tableView.responds(to:#selector(setter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        if tableView.responds(to:#selector(setter: UIView.layoutMargins)) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        
        /// 顶部
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        let imageV = UIImageView(image: #imageLiteral(resourceName: "icon_60x60_"))
        let descripLabel = UILabel()
        descripLabel.numberOfLines = 0
        descripLabel.textColor = UIColor(r: 152, g: 147, b: 130)
        descripLabel.text = "ofo 共享单车是全球第一个无桩共享单车出行平台，首创\"单车共享\"模式，用户只需在微信服务号或App输入车牌号，即可获得密码解锁用车，随取随用，随时随地。"
        descripLabel.sizeToFit()
        topView.addSubview(imageV)
        topView.addSubview(descripLabel)
        
        
        /// 底部
        let bottomView = UIView()
        let versionLabel = UILabel()
        versionLabel.textColor = UIColor(r: 221, g: 194, b: 190)
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.text = "当前版本：V\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)"
        
        let copyrightLabel = UILabel()
        copyrightLabel.textColor = UIColor(r: 221, g: 194, b: 190)
        copyrightLabel.font = UIFont.systemFont(ofSize: 13)
        copyrightLabel.text = "2017 ofo.so all rights reaerved"
        bottomView.addSubview(versionLabel)
        bottomView.addSubview(copyrightLabel)
        
        view.addSubview(topView)
        view.addSubview(tableView)
        view.addSubview(bottomView)

        
        /// 布局
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(navHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(descripLabel).offset(10)
        }
        
        imageV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.width.equalTo(60)
        }
        descripLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageV.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        copyrightLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(versionLabel.snp.bottom)
        }
    }
}
