//
//  HomeViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxCocoa

final class GoodsItemViewModel {

    init(with goods: Goods) {}

}

final class HomeViewModel: ViewModelType {

    // MARK: - properties

    private let navigator: HomeNavigator
    private let goodsUsecase: GoodsUsecase

    // MARK: - init/deinit

    init(navigator: HomeNavigator, goodsUsecase: GoodsUsecase) {
        self.navigator = navigator
        self.goodsUsecase = goodsUsecase
    }

    deinit {
        print("🗑", self)
    }

    // MARK: - methods

    func transform(input: Input) -> Output {

        let goodsItems = input.viewWillAppear.flatMapFirst { [unowned self] in
            self.goodsUsecase.goods()
                .asDriverOnErrorJustComplete()
                .map { $0.map { GoodsItemViewModel(with: $0) } }
        }

        return Output(goodsItems: goodsItems)
    }

}

// MARK: - EX: Input/Output

extension HomeViewModel {

    struct Input {
        let viewWillAppear: Driver<Void>
    }
    struct Output {
        let goodsItems: Driver<[GoodsItemViewModel]>
    }

}
