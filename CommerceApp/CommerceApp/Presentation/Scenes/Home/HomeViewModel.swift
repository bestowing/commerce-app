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
        let errorTacker = ErrorTracker()

        let isFetchingLimited = PublishSubject<Bool>()
        let goodsItems = PublishSubject<[GoodsItemViewModel]>()

        let initTrigger = Driver.of(Driver.just(()), input.refresh).merge()

        let initialization = initTrigger.flatMapLatest { [unowned self] _ in
            self.homeUsecase.initialization()
                .trackActivity(refreshIndicator)
                .asDriverOnErrorJustComplete()
        }

        let bannerItems = initialization
            .map { $0.0.map { BannerItemViewModel(with: $0) } }

        let initializedGoods = initialization
            .map { $0.1 }

        let moreLoadedGoods = input.loadMore
            .withLatestFrom(isFetchingLimited.asDriverOnErrorJustComplete())
            .filter { isEnd in isEnd == false }
            .withLatestFrom(goodsItems.asDriverOnErrorJustComplete())
            .compactMap { $0.last?.goods.id }
            .flatMapLatest { [unowned self] id in
                self.homeUsecase.pagination(after: id)
                    .asDriverOnErrorJustComplete()
            }

        let likesOfInitialGoods = initializedGoods
            .flatMapLatest { [unowned self] goods in
                self.homeUsecase.getLikesGoods(in: goods)
                    .asDriverOnErrorJustComplete()
            }

        let initializedGoodsItemsEvent = likesOfInitialGoods
            .withLatestFrom(initializedGoods) { ($0, $1) }
            .map { likes, goods -> [GoodsItemViewModel] in
                let viewModels = goods.map {
                    GoodsItemViewModel(with: $0, isLiked: likes.contains($0))
                }
                return viewModels
            }
            .do(onNext: { newGoodsViewModels in
                isFetchingLimited.onNext(newGoodsViewModels.isEmpty)
                goodsItems.onNext(newGoodsViewModels)
            })
            .mapToVoid()

        let likesOfAddedGoods = moreLoadedGoods
            .flatMap { [unowned self] goods in
                self.homeUsecase.getLikesGoods(in: goods)
                    .asDriverOnErrorJustComplete()
            }

        let addedGoodsItemsEvent = likesOfAddedGoods
            .withLatestFrom(moreLoadedGoods) { likes, goods -> [GoodsItemViewModel] in
                let viewModels = goods.map {
                    GoodsItemViewModel(with: $0, isLiked: likes.contains($0))
                }
                return viewModels
            }
            .withLatestFrom(goodsItems.asDriverOnErrorJustComplete()) { ($0, $1) }
            .do(onNext: { (newGoodsViewModels, goodsViewModels) in
                isFetchingLimited.onNext(newGoodsViewModels.isEmpty)
                if !newGoodsViewModels.isEmpty {
                    goodsItems.onNext(goodsViewModels + newGoodsViewModels)
                }
            })
            .mapToVoid()

        let likeEvent = input.like
            .filter { $0.isLiked == false }
            .flatMap { [unowned self] itemViewModel in
                self.homeUsecase.like(goods: itemViewModel.goods)
                    .trackError(errorTacker)
                    .asDriverOnErrorJustComplete()
                    .map { itemViewModel }
            }
            .withLatestFrom(goodsItems.asDriverOnErrorJustComplete()) { ($0, $1) }
            .do(onNext: { (newLikedGoods, goodsItemViewModels) in
                var goodsItemViewModels = goodsItemViewModels
                guard let index = goodsItemViewModels.firstIndex(of: newLikedGoods)
                else { return }
                goodsItemViewModels[index].isLiked = true
                goodsItems.onNext(goodsItemViewModels)
            })
            .mapToVoid()

        let unlikeEvent = input.like
            .filter { $0.isLiked }
            .flatMap { [unowned self] itemViewModel in
                return self.homeUsecase.unlike(goods: itemViewModel.goods)
                    .trackError(errorTacker)
                    .asDriverOnErrorJustComplete()
                    .map { itemViewModel }
            }
            .withLatestFrom(goodsItems.asDriverOnErrorJustComplete()) { ($0, $1) }
            .do(onNext: { (newUnlikedGoods, goodsItemViewModels) in
                var goodsItemViewModels = goodsItemViewModels
                guard let index = goodsItemViewModels.firstIndex(of: newUnlikedGoods)
                else { return }
                goodsItemViewModels[index].isLiked = false
                goodsItems.onNext(goodsItemViewModels)
            })
            .mapToVoid()

        let events = Driver.from([
            initializedGoodsItemsEvent, addedGoodsItemsEvent, likeEvent, unlikeEvent
        ]).merge()

        let homeSectionModels = Driver.combineLatest(
            bannerItems
                .map { HomeSectionModel.BannerSection(
                    items: $0.map { .BannerSectionItem(itemViewModel: $0) }
                )},
            goodsItems
                .asDriverOnErrorJustComplete()
                .map { HomeSectionModel.GoodsSection(
                    items: $0.map { .GoodsSectionItem(itemViewModel: $0) }
                )}
        ).map { [$0.0, $0.1] }

        return Output(
            homeSectionModels: homeSectionModels,
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
