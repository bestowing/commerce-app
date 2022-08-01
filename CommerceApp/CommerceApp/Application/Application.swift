//
//  Application.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import SDWebImage
import SDWebImageWebPCoder
import UIKit

final class Application {

    // MARK: - properties

    static let shared = Application()

    private let usecaseProvider: UsecaseProvider

    // MARK: - init/deinit

    private init() {
        self.usecaseProvider = DefaultUsecaseProvider()
        if #available(iOS 14.0, *) {
            let webP = SDImageAWebPCoder.shared
            SDImageCodersManager.shared.addCoder(webP)
        } else {
            let webP = SDImageWebPCoder.shared
            SDImageCodersManager.shared.addCoder(webP)
        }
    }

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
            navigationController: homeNavigationController,
            services: self.usecaseProvider
        )

        let likeNavigationController = UINavigationController()
        let likeButton = UITabBarItem(
            title: "좋아요",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        likeNavigationController.tabBarItem = likeButton
        let likeNavigator = DefaultLikeNavigator(
            navigationController: likeNavigationController,
            services: self.usecaseProvider
        )

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            homeNavigationController, likeNavigationController
        ]
        tabBarController.tabBar.tintColor = UIColor.accentColor
        homeNavigator.toHome()
        likeNavigator.toLike()

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

}
