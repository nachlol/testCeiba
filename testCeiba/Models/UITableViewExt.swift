//
//  UITableViewExt.swift
//  testCeiba
//
//  Created by Nicolas Chavez on 10/20/20.
//  Copyright © 2020 Nicolas Chavez. All rights reserved.
//

import Foundation

import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.init(named: "subtitleHomeColor")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Helvetica-Bold", size: 22)
        messageLabel.sizeToFit()
        messageLabel.backgroundColor = UIColor.init(named: "BackgroundSearchColor")
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
