//
//  UITableViewCell.swift
//  ZamzamUI
//
//  Created by Basem Emara on 4/30/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import ZamzamCore

public extension UITableViewCell {
    /// The color of the cell when it is selected.
    @objc dynamic var selectedBackgroundColor: UIColor? {
        get { selectedBackgroundView?.backgroundColor }

        set {
            guard selectionStyle != .none else { return }
            selectedBackgroundView = UIView().apply {
                $0.backgroundColor = newValue
            }
        }
    }
}
#endif
