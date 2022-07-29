//
//  GoodsItemViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

final class GoodsItemViewModel {

    // MARK: - properties

    var isLiked: Bool
    var discountRateString: String {
        return self.discountRate != 0 ? "\(self.discountRate)%" : ""
    }
    var discountRate: Int {
        return 100 - Int(Float(self.goods.price) / Float(self.goods.actualPrice) * 100)
    }
    var priceString: String {
        return self.goods.price.formattedString() ?? ""
    }
    var sellCountInfo: String {
        let sellCount = self.goods.sellCount
        if sellCount >= 10,
           let formattedString = sellCount.formattedString() {
            return "\(formattedString)개 구매중"
        }
        return ""
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
