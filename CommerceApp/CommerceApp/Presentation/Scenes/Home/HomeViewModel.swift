//
//  HomeViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

final class HomeViewModel: ViewModelType {

    // MARK: - init/deinit

    deinit {}

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
