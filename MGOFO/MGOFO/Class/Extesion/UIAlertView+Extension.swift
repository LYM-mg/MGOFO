//
//  UIAlertView+Extension.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 17/3/22.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

var dismissBlock: ((_ buttonIndex: NSInteger)->())?
var cancelBlock: (()->())?

extension UIAlertView: UIAlertViewDelegate {
    convenience init(title: String,message: String,cancleTitle: String,otherButtonTitle: [String], onDismissBlock:@escaping ((_ buttonIndex: NSInteger)->()),onCancleBlock: @escaping (()->())){
        self.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancleTitle)
        self.delegate = self
        dismissBlock = onDismissBlock
        cancelBlock = onCancleBlock
        for buttonTitle in otherButtonTitle {
            self.addButton(withTitle: buttonTitle)
        }
        self.show()
    }
    
    public func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            if ((cancelBlock) != nil) {
                cancelBlock!()
            }
        } else{
            if ((dismissBlock) != nil) {
                dismissBlock!(buttonIndex);
            }
        }
    }
}
