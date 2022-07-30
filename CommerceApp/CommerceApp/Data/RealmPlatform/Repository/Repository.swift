//
//  Repository.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import Foundation
import Realm
import RealmSwift
import RxRealm
import RxSwift

final class Repository<T: RealmRepresentable>: AbstractRepository where T == T.RealmType.DomainType, T.RealmType: Object {

    private var realm: Realm {
        return try! Realm()
    }

    private let scheduler: RunLoopThreadScheduler

    init() {
        let name = "Realm.Repository"
        self.scheduler = RunLoopThreadScheduler(threadName: name)
    }

    func queryAll() -> Observable<[T]> {
        let realm = self.realm
        let objects = realm.objects(T.RealmType.self)
        return Observable.collection(from: objects)
            .mapToDomain()
            .subscribe(on: scheduler)
    }

    func save(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.save(entity: entity)
        }.subscribe(on: scheduler)
    }

    func delete(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.delete(entity: entity)
        }.subscribe(on: scheduler)
    }

}
