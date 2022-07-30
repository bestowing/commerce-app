//
//  PaddingLabel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

import UIKit

final class PaddingLabel: UILabel {

    // MARK: - properties

    private var edgeInsets: UIEdgeInsets = UIEdgeInsets()

    // MARK: - init/deinit

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.edgeInsets = padding
    }

    // MARK: - methods

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.edgeInsets))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += self.edgeInsets.left + self.edgeInsets.right
        contentSize.height += self.edgeInsets.top + self.edgeInsets.bottom
        return contentSize
    }

}
