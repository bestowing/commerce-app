//
//  PageIndicatorView.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/31.
//

import RxSwift
import UIKit

struct PagingInfo: Equatable, Hashable {
    let section: Int
    let currentPage: Int
}

final class PageIndicatorView: UICollectionReusableView {

    // MARK: - properties

    private var disposeBag = DisposeBag()

    fileprivate var currentPageLabel: UILabel = {
        let label = PaddingLabel(
            padding: UIEdgeInsets(top: 5, left: 13, bottom: 5, right: 0)
        )
        label.font = UIFont.defaultFont(ofSize: .verySmall)
        label.textColor = .white
        return label
    }()
  
    private let totalPagesLabel: UILabel = {
        let label = PaddingLabel(
            padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 13)
        )
        label.font = UIFont.defaultFont(ofSize: .verySmall)
        label.textColor = .white
        return label
    }()

    // MARK: - init/deinit

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layoutViews()
    }

    private func layoutViews() {
        self.backgroundColor = .systemGray
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        self.addSubview(self.currentPageLabel)
        let divisor: UILabel = {
            let label = PaddingLabel(
                padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            )
            label.font = UIFont.defaultFont(ofSize: .verySmall)
            label.textColor = .white
            label.text = "/"
            return label
        }()
        self.addSubview(divisor)
        self.addSubview(self.totalPagesLabel)
        self.currentPageLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.size.equalTo(self.totalPagesLabel)
        }
        divisor.snp.makeConstraints {
            $0.leading.equalTo(self.currentPageLabel.snp.trailing)
            $0.top.bottom.equalToSuperview()
        }
        self.totalPagesLabel.snp.makeConstraints {
            $0.leading.equalTo(divisor.snp.trailing)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }

    // MARK: - methods

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

    func bind(currentPage: Observable<PagingInfo>, section: Int, totalCount: Int) {
        currentPage.asDriverOnErrorJustComplete()
            .filter { $0.section == section }
            .drive(self.rx.pagingInfo)
            .disposed(by: self.disposeBag)
        self.totalPagesLabel.text = "\(totalCount)"
    }

}

extension Reactive where Base: PageIndicatorView {

    var pagingInfo: Binder<PagingInfo> {
        return Binder(self.base) { sectionIndicatorView, pagingInfo in
            sectionIndicatorView.currentPageLabel.text = String(pagingInfo.currentPage + 1)
        }
    }

}
