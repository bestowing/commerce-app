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
        let refreshIndicator = ActivityIndicator()

        let isEnd = PublishSubject<Bool>()
        let goodsItems = PublishSubject<[GoodsItemViewModel]>()

        let initTrigger = Driver.of(Driver.just(()), input.refresh).merge()

        let initialization = initTrigger.flatMapLatest { [unowned self] _ in
            self.homeUsecase.initialization()
                .trackActivity(refreshIndicator)
                .asDriverOnErrorJustComplete()
        }

        let bannerItems = initialization
            .map { $0.0.map { BannerItemViewModel(with: $0) } }

        let intialGoodsItemsEvent = initialization
            .map { $0.1.map { GoodsItemViewModel(with: $0) } }
            .withLatestFrom(self.homeUsecase
                .observeInitialLikes()
                .asDriverOnErrorJustComplete()
            ) { viewModels, likes -> [GoodsItemViewModel] in
                likes.forEach { goods in
                    guard var viewModel = viewModels.first(where: { $0.goods == goods })
                    else { return }
                    viewModel.isLiked = true
                }
                return viewModels
            }
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
                if !$0.0.isEmpty {
                    goodsItems.onNext($0.1 + $0.0)
                }
            })
            .mapToVoid()

        let likeEvent: Driver<Void> = input.like
            .flatMap { [unowned self] itemViewModel in
                if itemViewModel.isLiked {
                    return self.homeUsecase.unlike(goods: itemViewModel.goods)
                        .asDriverOnErrorJustComplete()
                }
                return self.homeUsecase.like(goods: itemViewModel.goods)
                    .asDriverOnErrorJustComplete()
            }

        let events = Driver.from([
            intialGoodsItemsEvent, moreLoadedGoodsItems, likeEvent
        ]).merge()

        let homeSectionModels = Driver.combineLatest(
            bannerItems
                .map { HomeSectionModel(items: $0) },
            goodsItems
                .asDriverOnErrorJustComplete()
                .map { HomeSectionModel(items: $0) }
        ).map { [$0.0, $0.1] }

        return Output(
            homeSectionModels: homeSectionModels.debug(),
            isRefreshing: refreshIndicator.asDriver(),
            events: events
        )
    }

}

// MARK: - EX: Input/Output

extension HomeViewModel {

    struct Input {
        let loadMore: Driver<Void>
        let refresh: Driver<Void>
        let like: Driver<GoodsItemViewModel>
    }

    struct Output {
        let homeSectionModels: Driver<[HomeSectionModel]>
        let isRefreshing: Driver<Bool>
        let events: Driver<Void>
    }

}
