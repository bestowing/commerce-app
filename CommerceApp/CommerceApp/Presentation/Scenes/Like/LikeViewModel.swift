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
        let activityIndicator = ActivityIndicator()
        let errorTacker = ErrorTracker()

        let goodsItemViewModels = input.viewDidLoad
            .flatMap { [unowned self] in
                self.likeUsecase.likeGoods()
                    .trackActivity(activityIndicator)
                    .trackError(errorTacker)
                    .map { $0.map { GoodsItemViewModel(with: $0) } }
                    .asDriverOnErrorJustComplete()
            }

        let isLoading = activityIndicator.asDriver()

        let errorEvent = errorTacker.asDriver()
            .do(onNext: self.navigator.toErrorAlert)
            .mapToVoid()

        return Output(
            goodsItemViewModels: goodsItemViewModels,
            isLoading: isLoading,
            event: errorEvent
        )
    }

}

// MARK: - EX: Input/Output

extension LikeViewModel {

    struct Input {
        let viewDidLoad: Driver<Void>
    }
    struct Output {
        let goodsItemViewModels: Driver<[GoodsItemViewModel]>
        let isLoading: Driver<Bool>
        let event: Driver<Void>
    }

}
