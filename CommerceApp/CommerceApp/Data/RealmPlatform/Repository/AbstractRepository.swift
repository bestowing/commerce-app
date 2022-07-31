//
//  AbstractRepository.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import Foundation
import RxSwift

protocol AbstractRepository {

    associatedtype T

    func queryAll() -> Observable<[T]>
    func query(with predicate: NSPredicate) -> Observable<[T]>
    func save(entity: T) -> Observable<Void>
    func delete(entity: T) -> Observable<Void>

}
