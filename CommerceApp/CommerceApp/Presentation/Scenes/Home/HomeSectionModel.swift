//
//  HomeSectionModel.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/31.
//

import RxDataSources
import UIKit

protocol HomeSectionItemViewModel {

    var identifier: String { get }

}

protocol HomeSectionCell: UICollectionViewCell {

    func configure(with viewModel: HomeSectionItemViewModel)
    func configure(onTouched action: Action)

}

struct HomeSectionModel {

    var items: [Item]

}

extension HomeSectionModel: SectionModelType {

    typealias Item = HomeSectionItemViewModel

    init(original: HomeSectionModel, items: [Item]) {
        self = original
        self.items = items
    }

}
