//
//  Goods+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

extension Goods: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id, name, image
        case isNew = "is_new"
        case sellCount = "sell_count"
        case actualPrice = "actual_price"
        case price
    }

    // MARK: - init/deinit

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
        self.actualPrice = try container.decode(Int.self, forKey: .actualPrice)
        self.price = try container.decode(Int.self, forKey: .price)
        self.isNew = try container.decode(Bool.self, forKey: .isNew)
        self.sellCount = try container.decode(Int.self, forKey: .sellCount)
    }

}
