//
//  GoodsItemViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

final class GoodsItemViewModel {

    // MARK: - properties

    var isLiked: Bool

    let goods: Goods

    // MARK: - init/deinit

    convenience init(with goods: Goods) {
        self.init(with: goods, isLiked: false)
    }

    init(with goods: Goods, isLiked: Bool) {
        self.goods = goods
        self.isLiked = isLiked
    }

}
