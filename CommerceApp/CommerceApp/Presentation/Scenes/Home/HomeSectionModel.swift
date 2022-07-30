//
//  HomeSectionModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/31.
//

import RxDataSources

enum HomeSectionModel {
    case BannerSection(title: String, items: [SectionItem])
    case GoodsSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case BannerSectionItem(itemViewModel: BannerItemViewModel)
    case GoodsSectionItem(itemViewModel: GoodsItemViewModel)
}

extension HomeSectionModel: SectionModelType {

    typealias Item = SectionItem

    var items: [SectionItem] {
        switch self {
        case .BannerSection(title: _, items: let items):
            return items.map { $0 }
        case .GoodsSection(title: _, items: let items):
            return items.map { $0 }
        }
    }

    init(original: HomeSectionModel, items: [Item]) {
        switch original {
        case let .BannerSection(title: title, items: _):
            self = .BannerSection(title: title, items: items)
        case let .GoodsSection(title, _):
            self = .GoodsSection(title: title, items: items)
        }
    }

}
