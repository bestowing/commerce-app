//
//  LikeViewController.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import UIKit

final class LikeViewController: UIViewController {

    // MARK: - properties

    var viewModel: LikeViewModel!

    // MARK: - init/deinit

    deinit {
        print("🗑", Self.description())
    }

    // MARK: - methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
