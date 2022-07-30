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
        return Observable.deferred { [unowned self] in
            let objects = self.realm.objects(T.RealmType.self)

            return Observable.array(from: objects)
                .mapToDomain()
        }
        .subscribe(on: self.scheduler)
    }

    func initialization() -> Observable<[T]> {
        return Observable.deferred { [unowned self] in
            let objects = self.realm.objects(T.RealmType.self)

            return Observable.arrayWithChangeset(from: objects)
                .compactMap { array, changes -> [T.RealmType]? in
                    guard changes == nil
                    else { return nil }
                    return array
                }
                .mapToDomain()
        }
        .subscribe(on: self.scheduler)
    }

    func save(entity: T) -> Observable<Void> {
        return Observable.deferred { [unowned self] in
            return self.realm.rx.save(entity: entity)
        }
        .subscribe(on: scheduler)
    }

    func delete(entity: T) -> Observable<Void> {
        return Observable.deferred { [unowned self] in
            return self.realm.rx.delete(entity: entity)
        }
        .subscribe(on: scheduler)
    }

}
