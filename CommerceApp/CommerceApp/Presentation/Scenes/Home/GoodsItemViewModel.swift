//
//  GoodsItemViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

struct GoodsItemViewModel {

    // MARK: - properties

    var isLiked: Bool
    var discountRateString: String? {
        return self.discountRate != 0 ? "\(self.discountRate)%" : nil
    }
    var priceString: String {
        return self.goods.price.formattedString() ?? ""
    }
    var sellCountString: String {
        let sellCount = self.goods.sellCount
        if sellCount >= 10,
           let formattedString = sellCount.formattedString() {
            return "\(formattedString)개 구매중"
        }
        return ""
    }

    let goods: Goods

    private var discountRate: Int {
        return 100 - Int(Float(self.goods.price) / Float(self.goods.actualPrice) * 100)
    }

    // MARK: - init/deinit

    init(with goods: Goods) {
        self.init(with: goods, isLiked: false)
    }

    init(with goods: Goods, isLiked: Bool) {
        self.goods = goods
        self.isLiked = isLiked
    }

}

// MARK: - EX: Equatable

extension GoodsItemViewModel: Equatable {

    static func ==(lhs: GoodsItemViewModel, rhs: GoodsItemViewModel) -> Bool {
        return lhs.goods == rhs.goods && lhs.isLiked == rhs.isLiked
    }

}

extension GoodsItemViewModel: HomeSectionItemViewModel {

    var identifier: String { "GoodsCell" }

    static var identifier: String { "GoodsCell" }

}
