//
//  DefaultUsecaseProvider.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

final class DefaultUsecaseProvider: UsecaseProvider {

    // MARK: - properties

    private let networkProvider: NetworkProvider

    // MARK: - init/deinit

    init() {
        self.networkProvider = NetworkProvider()
    }

    // MARK: - methods

    func makeHomeUsecase() -> HomeUsecase {
        return DefaultHomeUsecase(
            network: self.networkProvider.makeHomeNetwork(),
            repository: Repository<Goods>()
        )
    }

}
