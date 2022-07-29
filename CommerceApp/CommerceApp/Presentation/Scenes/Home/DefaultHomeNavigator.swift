//
//  DefaultHomeNavigator.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import UIKit

final class DefaultHomeNavigator: HomeNavigator {

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

    func toHome() {
        let viewController = HomeViewController()
        viewController.viewModel = HomeViewModel(
            navigator: self, homeUsecase: self.services.makeHomeUsecase()
        )
        self.navigationController.pushViewController(viewController, animated: false)
    }

}
