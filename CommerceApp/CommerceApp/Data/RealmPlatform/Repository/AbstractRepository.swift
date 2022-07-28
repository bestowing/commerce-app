//
//  AbstractRepository.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift

protocol AbstractRepository {

    associatedtype T

    func queryAll() -> Observable<[T]>
    func save(_ entity: T) -> Observable<Void>

}
