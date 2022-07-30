//
//  HomeViewController.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxSwift
import SnapKit
import UIKit

final class HomeViewController: BaseViewController {

    // MARK: - properties

    var viewModel: HomeViewModel!

    private let refreshControl = UIRefreshControl()

    private lazy var homeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 120)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isUserInteractionEnabled = true
        collectionView.refreshControl = self.refreshControl
        collectionView.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.identifier)
        return collectionView
    }()

    private let disposeBag = DisposeBag()

    // MARK: - methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "홈"
        self.setSubViews()
        self.bindViewModel()
    }

    private func setSubViews() {
        self.view.addSubview(self.homeCollectionView)
        self.homeCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func bindViewModel() {
        assert(self.viewModel != nil)

        let like = PublishSubject<GoodsItemViewModel>()

        let input = HomeViewModel.Input(
            loadMore: self.homeCollectionView
                .loadMore()
                .asDriverOnErrorJustComplete(),
            refresh: self.refreshControl.rx
                .controlEvent(.valueChanged)
                .asDriverOnErrorJustComplete(),
            like: like.asDriverOnErrorJustComplete()
        )
        let output = self.viewModel.transform(input: input)

        output.goodsItems.drive(self.homeCollectionView.rx.items) { collectionView, index, viewModel in
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsCell.identifier, for: indexPath) as? GoodsCell
            else { return UICollectionViewCell() }
            cell.configure(onLiked: Action(
                action: { like.onNext(viewModel) }
            ))
            cell.bind(viewModel)
            return cell
        }.disposed(by: self.disposeBag)

        output.refreshing.drive(self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)

        output.events.drive()
            .disposed(by: self.disposeBag)
    }

}
