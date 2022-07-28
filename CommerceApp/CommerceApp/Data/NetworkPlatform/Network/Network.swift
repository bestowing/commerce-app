//
//  Network.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift

final class Network<T> {

    // MARK: - methods

    func getItems(_ path: String) -> Observable<T> {
        return Observable.create { _ in return Disposables.create() }
    }

}
