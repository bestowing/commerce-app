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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowScene = windowScene
        self.window = window
        Application.shared.setMainInterface(in: window)
    }

}
