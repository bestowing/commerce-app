//
//  RMGoods.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import RealmSwift

final class RMGoods: Object {

    @Persisted(primaryKey: true) var uid: String
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var isNew: Bool
    @Persisted var sellCount: Int
    @Persisted var actualPrice: Int
    @Persisted var price: Int

}

extension RMGoods: DomainConvertibleType {

    func asDomain() -> Goods {
        return Goods(
            id: Int(self.uid)!, name: self.name, image: self.image, isNew: self.isNew,
            sellCount: self.sellCount, actualPrice: self.actualPrice, price: self.price
        )
    }

}

extension Goods: RealmRepresentable {

    var uid: String {
        return String(self.id)
    }

    func asRealm() -> RMGoods {
        return RMGoods.build { object in
            object.uid = String(self.id)
            object.name = self.name
            object.image = self.image
            object.isNew = self.isNew
            object.sellCount = self.sellCount
            object.actualPrice = self.actualPrice
            object.price = self.price
        }
    }

}
