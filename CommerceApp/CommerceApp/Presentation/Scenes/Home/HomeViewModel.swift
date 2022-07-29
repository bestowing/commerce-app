//
//  HomeViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import Foundation
import RxCocoa
import RxSwift

final class HomeViewModel: ViewModelType {

    // MARK: - properties

    private let navigator: HomeNavigator
    private let homeUsecase: HomeUsecase

    // MARK: - init/deinit

    init(navigator: HomeNavigator, homeUsecase: HomeUsecase) {
        self.navigator = navigator
        self.homeUsecase = homeUsecase
    }

    deinit {
        print("🗑", self)
    }

    // MARK: - methods

    func transform(input: Input) -> Output {
        let isEnd = BehaviorSubject<Bool>(value: false)
        let goodsItems = BehaviorSubject<[GoodsItemViewModel]>(value: [])

        let initialization = input.viewWillAppear
            .flatMapFirst { [unowned self] in
                self.homeUsecase.initialization()
                    .asDriverOnErrorJustComplete()
            }
        

        let intialGoodsItemsEvent = initialization
            .map { $0.1.map { GoodsItemViewModel(with: $0) } }
            .do(onNext: {
                isEnd.onNext($0.isEmpty)
                goodsItems.onNext($0)
            })
            .mapToVoid()

        let moreLoadedGoodsItems = input.loadMore
            .withLatestFrom(isEnd.asDriverOnErrorJustComplete())
            .filter { !$0 }
            .withLatestFrom(goodsItems.asDriverOnErrorJustComplete())
            .compactMap { $0.last?.goods.id }
            .flatMapLatest { [unowned self] id in
                self.homeUsecase.pagination(after: id)
                    .asDriverOnErrorJustComplete()
                    .map { $0.map { GoodsItemViewModel(with: $0) } }
            }
            .withLatestFrom(goodsItems.asDriverOnErrorJustComplete()) { ($0, $1) }
            .do(onNext: {
                isEnd.onNext($0.0.isEmpty)
                goodsItems.onNext($0.1 + $0.0)
            })
            .mapToVoid()

        let events = Driver.from([
            intialGoodsItemsEvent, moreLoadedGoodsItems
        ]).merge()

        return Output(
            goodsItems: goodsItems
                .distinctUntilChanged()
                .asDriverOnErrorJustComplete(),
            events: events
        )
    }

}

// MARK: - EX: Input/Output

extension HomeViewModel {

    struct Input {
        let viewWillAppear: Driver<Void>
        let loadMore: Driver<Void>
    }

    struct Output {
        let goodsItems: Driver<[GoodsItemViewModel]>
        let events: Driver<Void>
    }

}
