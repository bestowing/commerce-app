//
//  Goods.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

struct Goods {

    let id: Int
    let name: String
    let image: String
    let isNew: Bool
    let sellCount: Int
    let actualPrice: Int
    let price: Int

}

extension Goods: Equatable {

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

}
