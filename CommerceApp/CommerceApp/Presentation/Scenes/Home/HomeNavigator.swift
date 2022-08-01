//
//  HomeNavigator.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import Foundation

protocol HomeNavigator {

    func toHome()
    func toErrorAlert(error: Error)

}
