//
//  DefaultLikeNavigator.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import UIKit

final class DefaultLikeNavigator: LikeNavigator {

    // MARK: - properties

    private let navigationController: UINavigationController
    private let services: UsecaseProvider

    // MARK: - init/deinit

    init(navigationController: UINavigationController, services: UsecaseProvider) {
        self.navigationController = navigationController
        self.services = services
    }

    deinit {
        print("🗑", self)
    }

    // MARK: - methods

    func toLike() {
        let viewController = LikeViewController()
        viewController.viewModel = LikeViewModel(
            navigator: self, likeUsecase: self.services.makeLikeUsecase()
        )
        self.navigationController.pushViewController(viewController, animated: false)
    }

}
