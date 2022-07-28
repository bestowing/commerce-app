//
//  HomeViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

final class HomeViewModel: ViewModelType {

    // MARK: - properties

    private let navigator: HomeNavigator

    // MARK: - init/deinit

    init(navigator: HomeNavigator) {
        self.navigator = navigator
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

extension HomeViewModel {

    struct Input {}
    struct Output {}

}
