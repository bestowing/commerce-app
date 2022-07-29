//
//  GoodsCell.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

import SnapKit
import UIKit

final class GoodsCell: UICollectionViewCell {

    // MARK: - properties

    private let goodsImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let discountRateLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let goodsNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let sellCountLabel: UILabel = {
        let label = UILabel()
        return label
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
        self.addSubview(self.goodsImageView)
        self.addSubview(self.likeImageView)
        self.addSubview(self.discountRateLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.goodsNameLabel)
        self.addSubview(self.badgeLabel)
        self.addSubview(self.sellCountLabel)
        self.goodsImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.size.equalTo(100)
        }
        self.likeImageView.snp.makeConstraints {
            $0.top.equalTo(self.goodsImageView).offset(5)
            $0.trailing.equalTo(self.goodsImageView).offset(-5)
            $0.size.equalTo(40)
        }
        self.discountRateLabel.snp.makeConstraints {
            $0.top.equalTo(self.goodsImageView)
            $0.leading.equalTo(self.goodsImageView.snp.trailing).offset(5)
        }
        self.priceLabel.snp.makeConstraints {
            $0.top.equalTo(self.discountRateLabel)
            $0.leading.equalTo(self.discountRateLabel.snp.trailing).offset(5)
        }
        self.goodsNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.discountRateLabel.snp.bottom).offset(5)
            $0.leading.equalTo(self.discountRateLabel)
        }
        self.badgeLabel.snp.makeConstraints {
            $0.top.equalTo(self.goodsNameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.discountRateLabel)
            $0.bottom.equalToSuperview().offset(-10)
        }
        self.sellCountLabel.snp.makeConstraints {
            $0.top.equalTo(self.badgeLabel)
            $0.leading.equalTo(self.badgeLabel.snp.trailing).offset(5)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }

    // MARK: - methods

    func bind(_ viewModel: GoodsItemViewModel) {
        self.goodsImageView.setGoodsImage(with: viewModel.goods.image)
        self.likeImageView.setLikeImage(isLiked: viewModel.isLiked)
        self.goodsNameLabel.text = viewModel.goods.name
    }

}

// MARK: - EX: UIImageView

fileprivate extension UIImageView {

    func setGoodsImage(with urlString: String) {
        let url = URL(string: urlString)
        self.setImage(
            with: url,
            placeholderImage: UIImage(systemName: "questionmark")
        )
    }

    func setLikeImage(isLiked: Bool) {
        self.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }

}
