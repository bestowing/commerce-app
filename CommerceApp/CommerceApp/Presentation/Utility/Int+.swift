//
//  Int+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/29.
//

import Foundation

extension Int {

    func formattedString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))
    }

}
