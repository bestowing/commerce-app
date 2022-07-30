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

    // MARK: - init/deinit

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    deinit {
        print("🗑", self)
    }

    // MARK: - methods

    func toLike() {
        let viewController = LikeViewController()
        viewController.viewModel = LikeViewModel(navigator: self)
        self.navigationController.pushViewController(viewController, animated: false)
    }

}
