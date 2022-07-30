//
//  DefaultHomeUsecase.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import RxSwift

final class DefaultHomeUsecase<Repository>: HomeUsecase where Repository: AbstractRepository, Repository.T == Goods {

    // MARK: - properties

    private let network: HomeNetwork
    private let repository: Repository

    // MARK: - init/deinit

    init(network: HomeNetwork, repository: Repository) {
        self.network = network
        self.repository = repository
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

    func like(goods: Goods) -> Observable<Void> {
        return self.repository.save(entity: goods)
    }

    func unlike(goods: Goods) -> Observable<Void> {
        return self.repository.delete(entity: goods)
    }

    func observeInitialLikes() -> Observable<[Goods]> {
        return self.repository.queryAll()
    }

}
