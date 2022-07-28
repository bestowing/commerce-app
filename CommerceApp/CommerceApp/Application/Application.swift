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

    func setMainInterface(in window: UIWindow) {
        let homeVC = HomeViewController()
        let homeButton = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        homeVC.tabBarItem = homeButton
        let homeNavigator = DefaultHomeNavigator()

        let likeVC = LikeViewController()
        let likeButton = UITabBarItem(
            title: "좋아요",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        likeVC.tabBarItem = likeButton
        let likeNavigator = DefaultLikeNavigator()

        let tapBarController = UITabBarController()
        tapBarController.viewControllers = [homeVC, likeVC]
        homeNavigator.toHome()
        likeNavigator.toLike()
        window.rootViewController = tapBarController
        window.makeKeyAndVisible()
    }

}
