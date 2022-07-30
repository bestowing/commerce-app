//
//  HomeSectionModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/31.
//

import RxDataSources

enum HomeSectionModel {
    case BannerSection(items: [SectionItem])
    case GoodsSection(items: [SectionItem])
}

enum SectionItem {
    case BannerSectionItem(itemViewModel: BannerItemViewModel)
    case GoodsSectionItem(itemViewModel: GoodsItemViewModel)
}

extension HomeSectionModel: SectionModelType {

    typealias Item = SectionItem

    // MARK: - properties

    var items: [SectionItem] {
        switch self {
        case .BannerSection(items: let items):
            return items.map { $0 }
        case .GoodsSection(items: let items):
            return items.map { $0 }
        }
    }

    // MARK: - init/deinit

    init(original: HomeSectionModel, items: [Item]) {
        switch original {
        case .BannerSection(_):
            self = .BannerSection(items: items)
        case .GoodsSection(_):
            self = .GoodsSection(items: items)
        }
    }

}
