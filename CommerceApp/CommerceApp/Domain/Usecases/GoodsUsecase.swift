//
//  GoodsUsecase.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift

protocol GoodsUsecase {

    func goods() -> Observable<[Goods]>
    func goods(after lastGoodsID: Int) -> Observable<[Goods]>

}
