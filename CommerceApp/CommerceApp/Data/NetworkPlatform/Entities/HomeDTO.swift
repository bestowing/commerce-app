//
//  HomeDTO.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

struct HomeDTO: Decodable {

    private enum CodingKeys: String, CodingKey {
        case banners, goods
    }

    // MARK: - properties

    let banners: [Banner]
    let goods: [Goods]

    // MARK: - init/deinit

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.banners = try container.decode([Banner].self, forKey: .banners)
        self.goods = try container.decode([Goods].self, forKey: .goods)
    }

}
