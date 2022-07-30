//
//  Realm+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import Realm
import RealmSwift
import RxSwift

extension Reactive where Base == Realm {

    // MARK: - methods

    func save<R: RealmRepresentable>(
        entity: R, update: Bool = true
    ) -> Observable<Void> where R.RealmType: Object {
        return Observable.create {
            do {
                try self.base.write {
                    self.base.add(entity.asRealm(), update: update ? .all : .error)
                }
                $0.onNext(())
                $0.onCompleted()
            } catch {
                $0.onError(error)
            }
            return Disposables.create()
        }
    }

    func delete<R: RealmRepresentable>(
        entity: R
    ) -> Observable<Void> where R.RealmType: Object {
        return Observable.create {
            do {
                guard let object = self.base.object(
                    ofType: R.RealmType.self, forPrimaryKey: entity.uid
                )
                else { fatalError() }
                try self.base.write {
                    self.base.delete(object)
                }
                $0.onNext(())
                $0.onCompleted()
            } catch {
                $0.onError(error)
            }
            return Disposables.create()
        }
    }

}
