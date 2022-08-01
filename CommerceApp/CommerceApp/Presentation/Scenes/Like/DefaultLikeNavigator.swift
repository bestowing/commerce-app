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

    private weak var presentingViewController: UIViewController?

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
        self.presentingViewController = viewController
    }

    func toErrorAlert(error: Error) {
        let alert = UIAlertController(title: "오류⚠️",
                                      message: "문제가 발생했습니다😢\n앱을 재실행해주세요",
                                      preferredStyle: UIAlertController.Style.alert)
        let confirm = UIAlertAction(title: "닫기", style: .default)
        alert.addAction(confirm)
        self.presentingViewController?.present(alert, animated: true)
    }

}
