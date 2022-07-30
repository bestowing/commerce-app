//
//  Action.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import Foundation

final class Action: NSObject {

    // MARK: - properties

    private let _action: () -> ()

    // MARK: - init/deinit

    init(action: @escaping () -> ()) {
        _action = action
        super.init()
    }

    // MARK: - methods

    @objc func performAction() {
        _action()
    }

}
