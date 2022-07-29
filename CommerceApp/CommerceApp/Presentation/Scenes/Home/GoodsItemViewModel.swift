//
//  GoodsItemViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

final class GoodsItemViewModel {

    // MARK: - properties

    var isLiked: Bool
    var discountRate: Int {
        return 100 - Int(Float(self.goods.price) / Float(self.goods.actualPrice) * 100)
    }
    var sellCountInfo: String {
        let sellCount = self.goods.sellCount
        return sellCount >= 10 ? "\(sellCount)개 구매중" : ""
    }
    var secondaryInfoCount: Int {
        let secondaryInfos: [Bool] = [
            self.goods.sellCount >= 10,
            self.goods.isNew
        ]
        return secondaryInfos.reduce(0) { $0 + ($1 ? 1 : 0) }
    }

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
