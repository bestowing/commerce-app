//
//  DefaultHomeNavigator.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import UIKit

final class DefaultHomeNavigator: HomeNavigator {

    private let navigationController: UINavigationController

    // MARK: - init/deinit

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    deinit {
        print("🗑", self)
    }

    // MARK: - methods

    func toHome() {
        let viewController = HomeViewController()
        viewController.viewModel = HomeViewModel(navigator: self)
        self.navigationController.pushViewController(viewController, animated: false)
    }

}
