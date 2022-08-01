//
//  DefaultHomeUsecase.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import Foundation
import RxSwift

final class DefaultHomeUsecase<Repository>: HomeUsecase where Repository: AbstractRepository, Repository.T == Goods {

    // MARK: - properties

    private let network: Network
    private let repository: Repository

    // MARK: - init/deinit

    init(network: Network, repository: Repository) {
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

    func getLikesGoods(in goods: [Goods]) -> Observable<[Goods]> {
        let predicate = NSPredicate(format: "uid IN %@", goods.map { String($0.id) })
        return self.repository.query(with: predicate)
    }

    func like(goods: Goods) -> Observable<Void> {
        return self.repository.save(entity: goods)
    }

    func unlike(goods: Goods) -> Observable<Void> {
        return self.repository.delete(entity: goods)
    }

}
