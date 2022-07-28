//
//  AbstractCache.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift

protocol AbstractCache {

    associatedtype T

    func queryAll() -> Observable<[T]>
    func save(_ entity: T) -> Observable<Void>

}
