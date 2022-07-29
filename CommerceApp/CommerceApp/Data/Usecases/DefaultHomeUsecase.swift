//
//  DefaultHomeUsecase.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import RxSwift

final class DefaultHomeUsecase: HomeUsecase {

    // MARK: - properties

    private let network: HomeNetwork

    // MARK: - init/deinit

    init(network: HomeNetwork) {
        self.network = network
    }

    // MARK: - methods

    func initialization() -> Observable<([Banner], [Goods])> {
        return self.network.fetchHomeDTO()
            .map { ($0.banners, $0.goods) }
    }

    func pagination(after lastGoodsID: Int) -> Observable<[Goods]> {
        return self.network.fetchGoodsDTO(after: lastGoodsID)
            .map { $0.goods }
    }

}
