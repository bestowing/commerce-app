//
//  HomeViewController.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import RxDataSources
import RxSwift
import SnapKit
import UIKit

final class HomeViewController: BaseViewController {

    // MARK: - properties

    var viewModel: HomeViewModel!

    private let like = PublishSubject<GoodsItemViewModel>()
    private let refreshControl = UIRefreshControl()

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath] {
        case let .BannerSectionItem(itemViewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BannerCell.identifier, for: indexPath
            ) as? BannerCell
            else { return UICollectionViewCell() }
            cell.bind(itemViewModel)
            return cell
        case let .GoodsSectionItem(itemViewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GoodsCell.identifier, for: indexPath
            ) as? GoodsCell
            else { return UICollectionViewCell() }
            cell.bind(onTouched: Action(
                action: { [unowned self] in
                    self.like.onNext(itemViewModel)
                }
            ))
            cell.bind(itemViewModel)
            return cell
        }
    })

    private lazy var homeCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return {
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(0.8)
                    )
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(0.8)
                    )
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: groupSize, subitems: [item]
                    )
                    let section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = 10.0
                    section.orthogonalScrollingBehavior = .continuous
                    section.contentInsets = NSDirectionalEdgeInsets(
                        top: 0, leading: 0, bottom: 20, trailing: 0
                    )
                    return section
                }()
            case 1:
                return {
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(130)
                    )
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(130)
                    )
                    let group = NSCollectionLayoutGroup.vertical(
                        layoutSize: groupSize, subitems: [item]
                    )
                    let section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = 20.0
                    return section
                }()
            default:
                return nil
            }
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isUserInteractionEnabled = true
        collectionView.refreshControl = self.refreshControl
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
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

        let input = HomeViewModel.Input(
            loadMore: self.homeCollectionView
                .loadMore()
                .asDriverOnErrorJustComplete(),
            refresh: self.refreshControl.rx
                .controlEvent(.valueChanged)
                .asDriverOnErrorJustComplete(),
            like: self.like.asDriverOnErrorJustComplete()
        )
        let output = self.viewModel.transform(input: input)

        output.homeSectionModels.drive(self.homeCollectionView.rx.items(
            dataSource: self.dataSource)
        )
            .disposed(by: self.disposeBag)

        output.isRefreshing.drive(self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)

        output.events.drive()
            .disposed(by: self.disposeBag)
    }

}
