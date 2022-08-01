//
//  LikeViewController.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift
import SnapKit
import UIKit

final class LikeViewController: BaseViewController {

    // MARK: - properties

    var viewModel: LikeViewModel!

    private lazy var likeGoodsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 130.0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.identifier)
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        return indicatorView
    }()

    private let disposeBag = DisposeBag()

    // MARK: - methods

    override func viewDidLoad() {
        self.title = "좋아요"
        self.setSubViews()
        self.bindViewModel()
        super.viewDidLoad()
    }

    private func setSubViews() {
        self.view.addSubview(self.likeGoodsCollectionView)
        self.view.addSubview(self.activityIndicator)
        self.likeGoodsCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }
    }

    private func bindViewModel() {
        assert(self.viewModel != nil)

        let input = LikeViewModel.Input(
            viewDidLoad: self.viewDidLoadTrigger.asDriverOnErrorJustComplete()
        )
        let output = self.viewModel.transform(input: input)

        output.goodsItemViewModels.drive(self.likeGoodsCollectionView.rx.items) { collectionView, index, viewModel in
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsCell.identifier, for: indexPath) as? GoodsCell
            else { return UICollectionViewCell() }
            cell.bind(viewModel)
            return cell
        }.disposed(by: self.disposeBag)

        output.isLoading.drive(self.activityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)

        output.event.drive()
            .disposed(by: self.disposeBag)
    }
}
