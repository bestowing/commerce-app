//
//  DefaultUsecaseProvider.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

final class DefaultUsecaseProvider: UsecaseProvider {

    // MARK: - methods

    func makeGoodsUsecase() -> GoodsUsecase {
        return DefaultGoodsUsecase()
    }

}
