//
//  HomeViewModelTests.swift
//  CommerceAppViewModelTests
//
//  Created by 이청수 on 2022/07/28.
//

import Quick
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
                context("초기값이 빈 배열이라면") {
                    it("빈 섹션 모델 배열을 방출해야 한다") {
                        
                    }
                }
                context("초기값이 길이가 1인 배열이라면") {
                    it("길이가 1인 섹션 모델 배열을 방출해야 한다") {
                        
                    }
                }
                context("초기값이 길이가 10인 배열이라면") {
                    it("길이가 10인 섹션 모델 배열을 방출해야 한다") {
                        
                    }
                }
            }
            context("홈 섹션 모델 배열을 방출할때") {
                context("배열 안에 이전에 좋아한 데이터가 없다면") {
                    it("상품 섹션의 아이템들에서 isLiked가 모두 false여야 한다") {
                        
                    }
                }
                context("배열 안에 이전에 좋아한 데이터가 1개라면") {
                    it("상품 섹션의 아이템들에서 좋아요한 데이터만 isLiked가 true여야 한다") {
                        
                    }
                }
                context("배열 안에 모든 데이터를 이전에 좋아했었다면") {
                    it("상품 섹션의 모든 아이템들에서 isLiked가 true여야 한다") {
                        
                    }
                }
            }
            context("추가로 요청했을때") {
                context("이전에 요청했던 결과가 길이가 0인 배열이라면") {
                    it("유즈케이스로 요청을 보내지 말아야한다") {
                        
                    }
                }
                context("이전에 요청했던 결과가 비어있지 않았고") {
                    context("추가로 받아오는 데이터가 길이가 0인 배열이라면") {
                        it("현재까지의 데이터가 그대로 방출되어야 한다") {
                            
                        }
                    }
                    context("추가로 받아오는 데이터가 길이가 1인 배열이라면") {
                        it("현재까지의 데이터의 상품 섹션에 길이가 1인 배열을 추가하여 방출되어야 한다") {
                            
                        }
                    }
                    context("추가로 받아오는 데이터가 길이가 10인 배열이라면") {
                        it("현재까지의 데이터의 상품 섹션에 길이가 10인 배열을 추가하여 방출되어야 한다") {
                            
                        }
                    }
                }
            }
            context("리프레시를 했을때") {
                it("초기값으로 섹션 모델을 만들어 방출해야 한다") {
                    
                }
            }
            context("하트모양 버튼을 눌렀을때") {
                context("좋아요하지 않았던 데이터였다면") {
                    it("선택한 데이터의 좋아요를 생성하는 요청을 유즈케이스로 보내야한다") {
                        
                    }
                }
                context("이미 좋아요한 데이터였다면") {
                    it("선택한 데이터의 좋아요를 삭제하는 요청을 유즈케이스로 보내야한다") {
                        
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
