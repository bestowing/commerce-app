//
//  DefaultGoodsUsecase.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift

final class DefaultGoodsUsecase: GoodsUsecase {

    func goods() -> Observable<[Goods]> {
        Observable.create { _ in Disposables.create() }
    }

}
