//
//  Object+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import RealmSwift

extension Object {

    static func build<O: Object>(_ builder: (O) -> () ) -> O {
        let object = O()
        builder(object)
        return object
    }

}
