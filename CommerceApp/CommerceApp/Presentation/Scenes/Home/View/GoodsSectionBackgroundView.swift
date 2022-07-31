//
//  GoodsSectionBackgroundView.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/31.
//

import UIKit

final class GoodsSectionBackgroundView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layoutViews()
    }

    private func layoutViews() {
        self.backgroundColor = .systemGray6
    }

}
