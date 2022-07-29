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

    private lazy var goodsPriceStack: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [self.discountRateLabel, self.priceLabel]
        )
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        return stackView
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
        label.numberOfLines = 0
        return label
    }()

    private lazy var secondaryInfoStack: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [self.badgeLabel, self.sellCountLabel]
        )
        stackView.axis = .horizontal
        stackView.spacing = 5.0
        return stackView
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
        self.contentView.addSubview(self.goodsImageView)
        self.contentView.addSubview(self.likeImageView)
        self.contentView.addSubview(self.goodsPriceStack)
        self.contentView.addSubview(self.goodsNameLabel)
        self.contentView.addSubview(self.secondaryInfoStack)
        self.goodsImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.bottom.lessThanOrEqualToSuperview().offset(-10)
            $0.size.equalTo(80)
        }
        self.likeImageView.snp.makeConstraints {
            $0.top.equalTo(self.goodsImageView).offset(5)
            $0.trailing.equalTo(self.goodsImageView).offset(-5)
            $0.size.equalTo(30)
        }
        self.goodsPriceStack.snp.makeConstraints {
            $0.top.equalTo(self.goodsImageView)
            $0.leading.equalTo(self.goodsImageView.snp.trailing).offset(5)
            $0.trailing.lessThanOrEqualToSuperview().offset(-10)
        }
        self.goodsNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.goodsPriceStack.snp.bottom).offset(5)
            $0.leading.equalTo(self.goodsPriceStack)
            $0.trailing.lessThanOrEqualToSuperview().offset(-10)
        }
        self.secondaryInfoStack.snp.makeConstraints {
            $0.top.equalTo(self.goodsNameLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalTo(self.goodsNameLabel)
            $0.trailing.lessThanOrEqualToSuperview().offset(-10)
        }
    }

    // MARK: - methods

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        self.layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }

    func bind(_ viewModel: GoodsItemViewModel) {
        self.goodsImageView.setGoodsImage(with: viewModel.goods.image)
        self.likeImageView.setLikeImage(isLiked: viewModel.isLiked)
        self.discountRateLabel.text = viewModel.discountRate > 0 ? "\(viewModel.discountRate)%" : ""
        self.goodsPriceStack.spacing = viewModel.discountRate > 0 ? 5 : 0
        self.priceLabel.text = String(viewModel.goods.price)
        self.goodsNameLabel.text = viewModel.goods.name
        self.badgeLabel.text = viewModel.goods.isNew ? "NEW" : ""
        self.secondaryInfoStack.spacing = viewModel.secondaryInfoCount >= 2 ? 5 : 0
        self.sellCountLabel.text = viewModel.sellCountInfo
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
