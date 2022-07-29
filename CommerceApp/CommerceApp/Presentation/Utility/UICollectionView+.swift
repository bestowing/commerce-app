//
//  UICollectionView+.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import RxSwift
import UIKit

extension UICollectionView {

    func loadMore() -> Observable<Void> {
        return self.rx.contentOffset.changed
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .filter { [unowned self] _ in
                self.isNearBottomEdge()
            }
            .mapToVoid()
    }

}

extension UIScrollView {

    fileprivate func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }

}
