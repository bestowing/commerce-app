//
//  Banner+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

extension Banner: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.image = try container.decode(String.self, forKey: .image)
    }

    enum CodingKeys: String, CodingKey {
        case id, image
    }

}
