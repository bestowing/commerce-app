//
//  BaseViewController.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - init/deinit

    deinit {
        print("🗑", Self.description())
    }

    // MARK: - methods

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
    }

}
