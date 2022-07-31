//
//  LikeViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import Foundation
import RxCocoa

final class LikeViewModel: ViewModelType {

    // MARK: - properties

    private let navigator: LikeNavigator
    private let likeUsecase: LikeUsecase

    // MARK: - init/deinit

    init(navigator: LikeNavigator, likeUsecase: LikeUsecase) {
        self.navigator = navigator
        self.likeUsecase = likeUsecase
    }

    deinit {
        print("🗑", self)
    }

    // MARK: - methods

    func transform(input: Input) -> Output {
        let errorTacker = ErrorTracker()

        let goodsItemViewModels = self.likeUsecase.likeGoods()
            .map { $0.map { GoodsItemViewModel(with: $0) } }
            .trackError(errorTacker)
            .asDriverOnErrorJustComplete()

        return Output(
            goodsItemViewModels: goodsItemViewModels,
            error: errorTacker.asDriver()
        )
    }

}

// MARK: - EX: Input/Output

extension LikeViewModel {

    struct Input {}
    struct Output {
        let goodsItemViewModels: Driver<[GoodsItemViewModel]>
        let error: Driver<Error>
    }

}
