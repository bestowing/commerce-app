//
//  SceneDelegate.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - properties

    var window: UIWindow?

    // MARK: - methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

}
