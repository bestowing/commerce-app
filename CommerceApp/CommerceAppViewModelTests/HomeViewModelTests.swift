//
//  HomeViewModelTests.swift
//  CommerceAppViewModelTests
//
//  Created by 이청수 on 2022/07/28.
//

import Quick
import RxCocoa
import RxSwift
import RxTest

final class HomeViewModelTests: QuickSpec {

    // MARK: - methods

    override func spec() {

        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var mockHomeNavigator: MockHomeNavigator!
        var mockHomeUsecase: MockHomeUsecase!
        var viewModel: HomeViewModel!

        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            disposeBag = DisposeBag()
            mockHomeNavigator = MockHomeNavigator()
            mockHomeUsecase = MockHomeUsecase()
            viewModel = HomeViewModel(
                navigator: mockHomeNavigator,
                homeUsecase: mockHomeUsecase
            )
        }

        describe("홈 뷰모델은") {
            context("뷰가 로드되었을때") {
                context("이전에 좋아요한 데이터가 없을때") {
                    context("초기값을 가져올때") {
                        context("배너와 상품 데이터 모두 빈 배열이라면") {
                            it("빈 섹션 모델 배열을 방출해야 한다") {
                                let testInitialValues: ([Banner], [Goods]) = ([], [])
                                let expectedSections = [
                                    HomeSectionModel.BannerSection(items: []),
                                    HomeSectionModel.GoodsSection(items: [])
                                ]
                                mockHomeUsecase.getLikesGoodsStream = scheduler.createHotObservable([
                                    .next(255, [Goods]())
                                ]).asObservable()
                                mockHomeUsecase.initializationStream = scheduler.createHotObservable([
                                    .next(250, testInitialValues)
                                ]).asObservable()
                                let testViewDidLoadTrigger = scheduler.createHotObservable(
                                    [.next(240, ())]
                                ).asDriverOnErrorJustComplete()
                                let input = HomeViewModel.Input(
                                    viewDidLoad: testViewDidLoadTrigger,
                                    loadMore: Driver<Void>.never(),
                                    refresh: Driver<Void>.never(),
                                    like: Driver<GoodsItemViewModel>.never()
                                )
                                let output = viewModel.transform(input: input)

                                let testableObserver = scheduler.createObserver([HomeSectionModel].self)
                                output.homeSectionModels
                                    .drive(testableObserver)
                                    .disposed(by: disposeBag)
                                output.events
                                    .drive()
                                    .disposed(by: disposeBag)

                                scheduler.start()
                                XCTAssertEqual(testableObserver.events, [
                                    .next(255, expectedSections)
                                ])
                            }
                        }
                        context("배너만 빈 배열이고 상품은 길이가 1이라면") {
                            it("빈 배너 섹션 모델과 길이가 1인 상품 섹션으로 배열을 만들어 방출해야 한다") {
                                let testGoods = Goods(
                                    id: 0, name: "", image: "", isNew: false,
                                    sellCount: 0, actualPrice: 0, price: 0
                                )
                                let testInitialValues: ([Banner], [Goods]) = ([], [testGoods])
                                let expectedSections = [
                                    HomeSectionModel.BannerSection(items: []),
                                    HomeSectionModel.GoodsSection(
                                        items: [
                                            .GoodsSectionItem(itemViewModel: GoodsItemViewModel(with: testGoods, isLiked: false))
                                        ]
                                    )
                                ]
                                mockHomeUsecase.getLikesGoodsStream = scheduler.createHotObservable([
                                    .next(255, [Goods]())
                                ]).asObservable()
                                mockHomeUsecase.initializationStream = scheduler.createHotObservable([
                                    .next(250, testInitialValues)
                                ]).asObservable()
                                let testViewDidLoadTrigger = scheduler.createHotObservable(
                                    [.next(240, ())]
                                ).asDriverOnErrorJustComplete()
                                let input = HomeViewModel.Input(
                                    viewDidLoad: testViewDidLoadTrigger,
                                    loadMore: Driver<Void>.never(),
                                    refresh: Driver<Void>.never(),
                                    like: Driver<GoodsItemViewModel>.never()
                                )
                                let output = viewModel.transform(input: input)

                                let testableObserver = scheduler.createObserver([HomeSectionModel].self)
                                output.homeSectionModels
                                    .drive(testableObserver)
                                    .disposed(by: disposeBag)
                                output.events
                                    .drive()
                                    .disposed(by: disposeBag)

                                scheduler.start()
                                XCTAssertEqual(testableObserver.events, [
                                    .next(255, expectedSections)
                                ])
                            }
                        }
                        context("배너와 상품 모두 길이가 1이라면") {
                            it("각 섹션 모두 길이가 1인 홈 섹션 배열을 만들어 방출해야 한다") {
                                let testBanner = Banner(id: 0, image: "")
                                let testGoods = Goods(
                                    id: 0, name: "", image: "", isNew: false,
                                    sellCount: 0, actualPrice: 0, price: 0
                                )
                                let testInitialValues: ([Banner], [Goods]) = ([testBanner], [testGoods])
                                let expectedSections = [
                                    HomeSectionModel.BannerSection(
                                        items: [
                                        .BannerSectionItem(itemViewModel: BannerItemViewModel(with: testBanner))
                                        ]
                                    ),
                                    HomeSectionModel.GoodsSection(
                                        items: [
                                            .GoodsSectionItem(itemViewModel: GoodsItemViewModel(with: testGoods, isLiked: false))
                                        ]
                                    )
                                ]
                                mockHomeUsecase.getLikesGoodsStream = scheduler.createHotObservable([
                                    .next(255, [Goods]())
                                ]).asObservable()
                                mockHomeUsecase.initializationStream = scheduler.createHotObservable([
                                    .next(250, testInitialValues)
                                ]).asObservable()
                                let testViewDidLoadTrigger = scheduler.createHotObservable(
                                    [.next(240, ())]
                                ).asDriverOnErrorJustComplete()
                                let input = HomeViewModel.Input(
                                    viewDidLoad: testViewDidLoadTrigger,
                                    loadMore: Driver<Void>.never(),
                                    refresh: Driver<Void>.never(),
                                    like: Driver<GoodsItemViewModel>.never()
                                )
                                let output = viewModel.transform(input: input)

                                let testableObserver = scheduler.createObserver([HomeSectionModel].self)
                                output.homeSectionModels
                                    .drive(testableObserver)
                                    .disposed(by: disposeBag)
                                output.events
                                    .drive()
                                    .disposed(by: disposeBag)

                                scheduler.start()
                                XCTAssertEqual(testableObserver.events, [
                                    .next(255, expectedSections)
                                ])
                            }
                        }
                    }
                    context("홈 섹션 모델 배열을 방출할때") {
                        it("상품 섹션의 아이템들에서 모든 데이터의 isLiked가 false여야 한다") {
                            let testGoods = (0..<10).map {
                                Goods(
                                    id: $0, name: "", image: "", isNew: false,
                                    sellCount: 0, actualPrice: 0, price: 0
                                )
                            }
                            let testInitialValues: ([Banner], [Goods]) = ([], testGoods)
                            let expected = Array(repeating: false, count: testGoods.count)
                            mockHomeUsecase.getLikesGoodsStream = scheduler.createHotObservable([
                                .next(255, [Goods]())
                            ]).asObservable()
                            mockHomeUsecase.initializationStream = scheduler.createHotObservable([
                                .next(250, testInitialValues)
                            ]).asObservable()
                            let testViewDidLoadTrigger = scheduler.createHotObservable(
                                [.next(240, ())]
                            ).asDriverOnErrorJustComplete()
                            let input = HomeViewModel.Input(
                                viewDidLoad: testViewDidLoadTrigger,
                                loadMore: Driver<Void>.never(),
                                refresh: Driver<Void>.never(),
                                like: Driver<GoodsItemViewModel>.never()
                            )
                            let output = viewModel.transform(input: input)

                            let testableObserver = scheduler.createObserver([Bool].self)
                            output.homeSectionModels
                                .compactMap { models -> [Bool]? in
                                    switch models[1] {
                                    case let .GoodsSection(items):
                                        return items.compactMap {
                                            switch $0 {
                                            case let .GoodsSectionItem(itemViewModel):
                                                return itemViewModel.isLiked
                                            default:
                                                return nil
                                            }
                                        }
                                    default:
                                        return nil
                                    }
                                }
                                .drive(testableObserver)
                                .disposed(by: disposeBag)
                            output.events
                                .drive()
                                .disposed(by: disposeBag)

                            scheduler.start()
                            XCTAssertEqual(testableObserver.events, [
                                .next(255, expected)
                            ])
                        }
                    }
                }
            }
        }
    }

}

extension HomeViewModelTests {

    final class MockHomeNavigator: HomeNavigator {
        func toHome() {}
    }

    final class MockHomeUsecase: HomeUsecase {

        var initializationStream: Observable<([Banner], [Goods])>
        var paginationStream: Observable<[Goods]>
        var getLikesGoodsStream: Observable<[Goods]>
        var likeStream: Observable<Void>
        var unlikeStream: Observable<Void>

        init() {
            self.initializationStream = PublishSubject<([Banner], [Goods])>()
            self.paginationStream = PublishSubject<[Goods]>()
            self.getLikesGoodsStream = PublishSubject<[Goods]>()
            self.likeStream = PublishSubject<Void>()
            self.unlikeStream = PublishSubject<Void>()
        }

        func initialization() -> Observable<([Banner], [Goods])> {
            return self.initializationStream.asObservable()
        }
        
        func pagination(after lastGoodsID: Int) -> Observable<[Goods]> {
            return self.paginationStream.asObservable()
        }
        
        func getLikesGoods(in goods: [Goods]) -> Observable<[Goods]> {
            return self.getLikesGoodsStream.asObservable()
        }
        
        func like(goods: Goods) -> Observable<Void> {
            return self.likeStream.asObservable()
        }
        
        func unlike(goods: Goods) -> Observable<Void> {
            return self.unlikeStream.asObservable()
        }
    }

}
