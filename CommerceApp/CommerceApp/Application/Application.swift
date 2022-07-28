//
//  Application.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import UIKit

final class Application {

    // MARK: - properties

    static let shared = Application()

    // MARK: - init/deinit

    private init() {}

    // MARK: - methods

    /// window에 main 인터페이스를 설정합니다
    func setMainInterface(in window: UIWindow) {
        let homeNavigationController = UINavigationController()
        let homeButton = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        homeNavigationController.tabBarItem = homeButton
        let homeNavigator = DefaultHomeNavigator(
            navigationController: homeNavigationController
        )

        let likeNavigationController = UINavigationController()
        let likeButton = UITabBarItem(
            title: "좋아요",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        likeNavigationController.tabBarItem = likeButton
        let likeNavigator = DefaultLikeNavigator(
            navigationController: likeNavigationController
        )

        let tapBarController = UITabBarController()
        tapBarController.viewControllers = [
            homeNavigationController, likeNavigationController
        ]
        homeNavigator.toHome()
        likeNavigator.toLike()

        window.rootViewController = tapBarController
        window.makeKeyAndVisible()
    }

}
