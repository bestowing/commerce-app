//
//  BannerCell.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/31.
//

import SnapKit
import UIKit

final class BannerCell: UICollectionViewCell {

    // MARK: - properties

    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - init/deinit

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layoutViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutViews()
    }

    private func layoutViews() {
        self.contentView.addSubview(self.bannerImageView)
        self.bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind(_ viewModel: BannerItemViewModel) {
        self.bannerImageView.setImage(
            with: URL(string: viewModel.banner.image), placeholderImage: nil
        )
    }

}
