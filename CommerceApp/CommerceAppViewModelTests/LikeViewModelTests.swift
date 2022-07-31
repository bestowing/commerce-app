//
//  LikeViewModelTests.swift
//  CommerceAppViewModelTests
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift
import RxTest
import XCTest

final class LikeViewModelTests: XCTestCase {

    // MARK: - properties

    private var mockLikeNavigator: MockLikeNavigator!
    private var mockLikeUsecase: MockLikeUsecase!
    private var viewModel: LikeViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    // MARK: - methods

    override func setUp() {
        super.setUp()
        self.mockLikeNavigator = MockLikeNavigator()
        self.mockLikeUsecase = MockLikeUsecase()
        self.viewModel = LikeViewModel(
            navigator: self.mockLikeNavigator,
            likeUsecase: self.mockLikeUsecase
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        mockLikeNavigator = nil
        mockLikeUsecase = nil
        viewModel = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }

}

extension LikeViewModelTests {

    final class MockLikeNavigator: LikeNavigator {
        func toLike() {}
    }

    final class MockLikeUsecase: LikeUsecase {

        var likeGoodsStream = PublishSubject<[Goods]>()

        func likeGoods() -> Observable<[Goods]> {
            return self.likeGoodsStream.asObservable()
        }
        
    }

}
