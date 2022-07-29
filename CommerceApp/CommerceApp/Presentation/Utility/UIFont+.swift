//
//  UIFont+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

import UIKit

extension UIFont {

    enum FontSize: CGFloat {
        case large = 20.0
        case medium = 16.0
    }

    static func defaultFont(ofSize size: FontSize, weight: Weight) -> UIFont {
        return UIFont.systemFont(ofSize: size.rawValue, weight: weight)
    }

}
