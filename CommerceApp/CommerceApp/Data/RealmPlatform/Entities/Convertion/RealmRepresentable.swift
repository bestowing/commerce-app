//
//  RealmRepresentable.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

protocol RealmRepresentable {

    associatedtype RealmType: DomainConvertibleType

    var uid: String { get }

    func asRealm() -> RealmType

}
