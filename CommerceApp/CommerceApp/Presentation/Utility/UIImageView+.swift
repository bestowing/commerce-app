//
//  UIImageView+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

import SDWebImage
import UIKit

extension UIImageView {

    func setImage(with url: URL?, placeholderImage: UIImage?) {
        self.sd_setImage(with: url, placeholderImage: placeholderImage)
    }

    func setImage(with url: URL?) {
        self.sd_setImage(with: url)
    }

}
