//
//  Action.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import Foundation

final class Action: NSObject {

    private let _action: () -> ()

    init(action: @escaping () -> ()) {
        _action = action
        super.init()
    }

    @objc func performAction() {
        _action()
    }

}
