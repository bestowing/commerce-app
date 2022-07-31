//
//  GoodsCell.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

import SnapKit
import UIKit

class GoodsCell: UICollectionViewCell {

    // MARK: - properties

    fileprivate let goodsImageView: UIImageView = {
        // TODO: placeholder 이미지 바꾸기
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7.0
        imageView.layer.masksToBounds = true
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
        label.textColor = UIColor.accentColor
        label.font = UIFont.defaultFont(ofSize: .large, weight: .semibold)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textPrimary
        label.font = UIFont.defaultFont(ofSize: .large, weight: .semibold)
        return label
    }()

    private let goodsNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textSecondary
        label.font = UIFont.defaultFont(ofSize: .medium)
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
        let label = PaddingLabel(
            padding: UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        )
        label.text = "NEW"
        label.layer.cornerRadius = 5.0
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.textSecondary?.cgColor
        label.font = UIFont.defaultFont(ofSize: .verySmall)
        return label
    }()

    private let sellCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textSecondary
        label.font = UIFont.defaultFont(ofSize: .small)
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
        self.contentView.addSubview(self.goodsPriceStack)
        self.contentView.addSubview(self.goodsNameLabel)
        self.contentView.addSubview(self.secondaryInfoStack)
        self.goodsImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.bottom.lessThanOrEqualToSuperview().offset(-10)
            $0.size.equalTo(80)
        }
        self.goodsPriceStack.snp.makeConstraints {
            $0.top.equalTo(self.goodsImageView).offset(2)
            $0.leading.equalTo(self.goodsImageView.snp.trailing).offset(13)
            $0.trailing.lessThanOrEqualToSuperview().offset(-10)
        }
        self.goodsNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.goodsPriceStack.snp.bottom).offset(10)
            $0.leading.equalTo(self.goodsPriceStack)
            $0.trailing.lessThanOrEqualToSuperview().offset(-10)
        }
        self.secondaryInfoStack.snp.makeConstraints {
            $0.top.equalTo(self.goodsNameLabel.snp.bottom).offset(20)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        if self.discountRateLabel.superview == nil {
            self.goodsPriceStack.insertArrangedSubview(self.discountRateLabel, at: 0)
        }
        if self.badgeLabel.superview == nil {
            self.secondaryInfoStack.insertArrangedSubview(self.badgeLabel, at: 0)
        }
    }

    func bind(_ viewModel: GoodsItemViewModel) {
        self.goodsImageView.setGoodsImage(with: viewModel.goods.image)
        if let discountRateString = viewModel.discountRateString {
            self.discountRateLabel.text = discountRateString
        } else {
            self.discountRateLabel.removeFromSuperview()
        }
        self.priceLabel.text = viewModel.priceString
        self.goodsNameLabel.text = viewModel.goods.name
        if !viewModel.goods.isNew {
            self.badgeLabel.removeFromSuperview()
        }
        self.sellCountLabel.text = viewModel.sellCountString
    }

}

final class LikeEnabledGoodsCell: GoodsCell {

    // MARK: - properties

    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.contentMode = .scaleAspectFill
        return button
    }()

    private var action: Action?

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
        self.contentView.addSubview(self.likeButton)
        self.likeButton.snp.makeConstraints {
            $0.top.equalTo(self.goodsImageView).offset(5)
            $0.trailing.equalTo(self.goodsImageView).offset(-5)
            $0.size.equalTo(30)
        }
    }

    // MARK: - methods

    func bind(onTouched action: Action) {
        self.likeButton.addTarget(
            action, action: #selector(action.performAction), for: .touchUpInside
        )
        self.action = action
    }

    override func bind(_ viewModel: GoodsItemViewModel) {
        super.bind(viewModel)
        self.likeButton.tintColor = viewModel.isLiked ? UIColor.accentColor : .white
        self.likeButton.setBackgroundImage(
            viewModel.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal
        )
    }
}
