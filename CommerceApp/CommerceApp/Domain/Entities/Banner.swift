//
//  Banner.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

struct Banner: Equatable {

    let id: Int
    let image: String

    static func ==(lhs: Banner, rhs: Banner) -> Bool {
        return lhs.id == rhs.id
    }

}
