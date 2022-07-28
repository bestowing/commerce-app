//
//  RealmRepository.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift

final class RealmRepository<T>: AbstractRepository {

    func queryAll() -> Observable<[T]> {
        return Observable.create { _ in return Disposables.create() }
    }

    func save(_ entity: T) -> Observable<Void> {
        return Observable.create { _ in return Disposables.create() }
    }

}