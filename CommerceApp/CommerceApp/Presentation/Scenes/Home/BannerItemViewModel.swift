//
//  BannerItemViewModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/31.
//

struct BannerItemViewModel {

    let banner: Banner

    init(with banner: Banner) {
        self.banner = banner
    }

}

extension BannerItemViewModel: HomeSectionItemViewModel {

    var identifier: String { "BannerCell" }

    static var identifier: String { "BannerCell" }

}
