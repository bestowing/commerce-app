//
//  DefaultUsecaseProvider.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

final class DefaultUsecaseProvider: UsecaseProvider {

    // MARK: - properties

    private let networkProvider: NetworkProvider
    private let goodsRepository: Repository<Goods>

    // MARK: - init/deinit

    init() {
        self.networkProvider = NetworkProvider()
        self.goodsRepository = Repository<Goods>()
    }

    // MARK: - methods

    func makeHomeUsecase() -> HomeUsecase {
        return DefaultHomeUsecase(
            network: self.networkProvider.makeHomeNetwork(),
            repository: self.goodsRepository
        )
    }

    func makeLikeUsecase() -> LikeUsecase {
        return DefaultLikeUsecase(
            repository: self.goodsRepository
        )
    }

}
