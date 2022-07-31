//
//  HomeViewModelTests.swift
//  CommerceAppViewModelTests
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift
import RxTest
import XCTest

final class HomeViewModelTests: XCTestCase {

    // MARK: - properties

    private var mockHomeNavigator: MockHomeNavigator!
    private var mockHomeUsecase: MockHomeUsecase!
    private var viewModel: HomeViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    // MARK: - methods

    override func setUp() {
        super.setUp()
        self.mockHomeNavigator = MockHomeNavigator()
        self.mockHomeUsecase = MockHomeUsecase()
        self.viewModel = HomeViewModel(
            navigator: self.mockHomeNavigator,
            homeUsecase: self.mockHomeUsecase
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        self.mockHomeNavigator = nil
        self.mockHomeUsecase = nil
        self.viewModel = nil
        self.disposeBag = nil
        self.scheduler = nil
        super.tearDown()
    }

}

extension HomeViewModelTests {

    final class MockHomeNavigator: HomeNavigator {
        func toHome() {}
    }

    final class MockHomeUsecase: HomeUsecase {

        var initializationStream = PublishSubject<([Banner], [Goods])>()
        var paginationStream = PublishSubject<[Goods]>()
        var getLikesGoodsStream = PublishSubject<[Goods]>()
        var likeStream = PublishSubject<Void>()
        var unlikeStream = PublishSubject<Void>()

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
