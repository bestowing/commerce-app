//
//  Observable+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

import RxCocoa
import RxSwift

extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }

}
