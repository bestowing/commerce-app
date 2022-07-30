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
    func like(goods: Goods) -> Observable<Void>
    func unlike(goods: Goods) -> Observable<Void>
    func observeInitialLikes() -> Observable<[Goods]>
    func observeLikesAdded() -> Observable<[Goods]>
    func observeLikesRemoved() -> Observable<[Goods]>

}
