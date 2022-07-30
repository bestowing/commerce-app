//
//  Observable+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import RxSwift

extension Observable where Element: Sequence, Element.Iterator.Element: DomainConvertibleType {

    typealias DomainType = Element.Iterator.Element.DomainType

    // MARK: - methods

    func mapToDomain() -> Observable<[DomainType]> {
        return map { sequence -> [DomainType] in
            return sequence.mapToDomain()
        }
    }

}

extension Sequence where Iterator.Element: DomainConvertibleType {

    typealias Element = Iterator.Element

    // MARK: - methods

    func mapToDomain() -> [Element.DomainType] {
        return map {
            return $0.asDomain()
        }
    }

}
