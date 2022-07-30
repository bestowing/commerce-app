//
//  DefaultLikeUsecase.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/31.
//

import RxSwift

final class DefaultLikeUsecase<Repository>: LikeUsecase where Repository: AbstractRepository, Repository.T == Goods {

    // MARK: - properties

    private let repository: Repository

    // MARK: - init/deinit

    init(repository: Repository) {
        self.repository = repository
    }

    // MARK: - methods

    func likeGoods() -> Observable<[Goods]> {
        return self.repository.queryAll()
    }

}
