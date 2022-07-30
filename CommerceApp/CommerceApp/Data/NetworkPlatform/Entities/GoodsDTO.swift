//
//  GoodsDTO.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

struct GoodsDTO: Decodable {

    private enum CodingKeys: String, CodingKey {
        case goods
    }

    // MARK: - properties

    let goods: [Goods]

    // MARK: - init/deinit

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.goods = try container.decode([Goods].self, forKey: .goods)
    }

}
