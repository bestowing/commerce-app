//
//  HomeUsecase.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import RxSwift

protocol HomeUsecase {

    func initialization() -> Observable<([Banner], [Goods])>
    func pagination(after lastGoodsID: Int) -> Observable<[Goods]>

}

