//
//  LikeViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

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
        return Output()
    }

}

// MARK: - EX: Input/Output

extension LikeViewModel {

    struct Input {}
    struct Output {}

}
