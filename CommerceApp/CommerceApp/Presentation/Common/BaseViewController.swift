//
//  BaseViewController.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift
import UIKit

class BaseViewController: UIViewController {

    let viewDidLoadTrigger = PublishSubject<Void>()

    // MARK: - init/deinit

    deinit {
        print("🗑", Self.description())
    }

    // MARK: - methods

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidLoadTrigger.onNext(())
    }

}
