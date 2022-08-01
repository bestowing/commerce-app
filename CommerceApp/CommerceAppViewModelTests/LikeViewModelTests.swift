//
//  LikeViewModelTests.swift
//  CommerceAppViewModelTests
//
//  Created by 이청수 on 2022/07/28.
//

import Quick
import RxSwift
import RxTest

final class LikeViewModelTests: QuickSpec {

    // MARK: - methods

    override func spec() {

        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var mockLikeNavigator: MockLikeNavigator!
        var mockLikeUsecase: MockLikeUsecase!
        var viewModel: LikeViewModel!

        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            disposeBag = DisposeBag()
            mockLikeNavigator = MockLikeNavigator()
            mockLikeUsecase = MockLikeUsecase()
            viewModel = LikeViewModel(
                navigator: mockLikeNavigator, likeUsecase: mockLikeUsecase
            )
        }

        describe("좋아요 뷰모델은") {
            context("유즈케이스에서 좋아요한 제품을 0개 방출한다면") {
                it("빈 배열을 방출해야 한다") {
                    let testGoods: [Goods] = []
                    let expectedItemViewModels: [GoodsItemViewModel] = []
                    mockLikeUsecase.likeGoodsStream = scheduler.createHotObservable([
                        .next(250, testGoods)
                    ]).asObservable()
                    let testViewDidLoadTrigger = scheduler.createHotObservable([
                        .next(240, ())
                    ]).asDriverOnErrorJustComplete()
                    let input = LikeViewModel.Input(
                        viewDidLoad: testViewDidLoadTrigger
                    )
                    let output = viewModel.transform(input: input)
                    
                    let testableObserver = scheduler.createObserver([GoodsItemViewModel].self)
                    output.goodsItemViewModels
                        .drive(testableObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    XCTAssertEqual(testableObserver.events, [
                        .next(250, expectedItemViewModels)
                    ])
                }
            }
            context("유즈케이스에서 좋아요한 제품을 1개 방출한다면") {
                it("좋아요한 1개 제품을 방출해야 한다") {
                    let testGoods = [Goods(id: 0, name: "", image: "", isNew: false, sellCount: 0, actualPrice: 0, price: 0)]
                    let expectedItemViewModels = testGoods.map { GoodsItemViewModel(with: $0) }
                    mockLikeUsecase.likeGoodsStream = scheduler.createHotObservable([
                        .next(250, testGoods)
                    ]).asObservable()
                    let testViewDidLoadTrigger = scheduler.createHotObservable([
                        .next(240, ())
                    ]).asDriverOnErrorJustComplete()
                    let input = LikeViewModel.Input(
                        viewDidLoad: testViewDidLoadTrigger
                    )
                    let output = viewModel.transform(input: input)

                    let testableObserver = scheduler.createObserver([GoodsItemViewModel].self)
                    output.goodsItemViewModels
                        .drive(testableObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    XCTAssertEqual(testableObserver.events, [
                        .next(250, expectedItemViewModels)
                    ])
                }
                context("유즈케이스에서 좋아요한 제품을 10개 방출한다면") {
                    it("좋아요한 10개 제품을 방출해야 한다") {
                        let testGoods = (0..<10).map {
                            Goods(id: $0, name: "", image: "", isNew: false, sellCount: 0, actualPrice: 0, price: 0)
                        }
                        let expectedItemViewModels = testGoods.map { GoodsItemViewModel(with: $0) }
                        mockLikeUsecase.likeGoodsStream = scheduler.createHotObservable([
                            .next(250, testGoods)
                        ]).asObservable()
                        let testViewDidLoadTrigger = scheduler.createHotObservable([
                            .next(240, ())
                        ]).asDriverOnErrorJustComplete()
                        let input = LikeViewModel.Input(
                            viewDidLoad: testViewDidLoadTrigger
                        )
                        let output = viewModel.transform(input: input)

                        let testableObserver = scheduler.createObserver([GoodsItemViewModel].self)
                        output.goodsItemViewModels
                            .drive(testableObserver)
                            .disposed(by: disposeBag)

                        scheduler.start()
                        XCTAssertEqual(testableObserver.events, [
                            .next(250, expectedItemViewModels)
                        ])
                    }
                }
            }
        }
    }

}

extension LikeViewModelTests {

    final class MockLikeNavigator: LikeNavigator {
        func toLike() {}
    }

    final class MockLikeUsecase: LikeUsecase {

        var likeGoodsStream: Observable<[Goods]>

        init() {
            self.likeGoodsStream = PublishSubject<[Goods]>()
        }

        func likeGoods() -> Observable<[Goods]> {
            return self.likeGoodsStream
        }

    }

}
