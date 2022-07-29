//
//  GoodsDTO.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import Foundation

struct GoodsDTO: Decodable {

    let goods: [Goods]

    private enum CodingKeys: String, CodingKey {
        case goods
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.goods = try container.decode([Goods].self, forKey: .goods)
    }

}
