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

    private let likeGoodsViewModelSubject = PublishSubject<GoodsItemViewModel>()
    private let pagingInfoSubject = PublishSubject<PagingInfo>()

    private let refreshControl = UIRefreshControl()

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
        switch item {
        case let .BannerSectionItem(itemViewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BannerCell.identifier, for: indexPath
            ) as? BannerCell
            else { return UICollectionViewCell() }
            cell.bind(itemViewModel)
            return cell
        case let .GoodsSectionItem(itemViewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LikeEnabledGoodsCell.identifier,
                for: indexPath
            ) as? LikeEnabledGoodsCell
            else { return UICollectionViewCell() }
            cell.bind(onTouched: Action(
                action: { [unowned self] in
                    self.likeGoodsViewModelSubject.onNext(itemViewModel)
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
                        heightDimension: .fractionalWidth(0.7)
                    )
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(0.7)
                    )
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: groupSize, subitems: [item]
                    )
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .paging
                    let indicatorSize = NSCollectionLayoutSize(
                        widthDimension: .estimated(60), heightDimension: .estimated(30)
                    )
                    let itemAnchor = NSCollectionLayoutAnchor(
                        edges: [.bottom, .trailing], absoluteOffset: CGPoint(x: -15, y: -10)
                    )
                    let indicator = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: indicatorSize, elementKind: PageIndicatorView.identifier, containerAnchor: itemAnchor
                    )
                    indicator.pinToVisibleBounds = true
                    indicator.zIndex = 2
                    section.boundarySupplementaryItems = [indicator]
                    section.visibleItemsInvalidationHandler = { [unowned self] (_, offset, _) in
                        let page = Int(round(offset.x / self.view.bounds.width))
                        self.pagingInfoSubject.onNext(
                            PagingInfo(section: sectionIndex, currentPage: page)
                        )
                    }
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
                    section.interGroupSpacing = 1
                    let decorationView = NSCollectionLayoutDecorationItem.background(elementKind: GoodsSectionBackgroundView.identifier)
                    section.decorationItems = [decorationView]
                    return section
                }()
            default:
                return nil
            }
        }
        layout.register(
            GoodsSectionBackgroundView.self,
            forDecorationViewOfKind: GoodsSectionBackgroundView.identifier
        )
        let layoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfiguration.interSectionSpacing = 5
        layout.configuration = layoutConfiguration

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isUserInteractionEnabled = true
        collectionView.refreshControl = self.refreshControl
        collectionView.register(
            BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier
        )
        collectionView.register(
            LikeEnabledGoodsCell.self, forCellWithReuseIdentifier: LikeEnabledGoodsCell.identifier
        )
        collectionView.register(
            PageIndicatorView.self,
            forSupplementaryViewOfKind: PageIndicatorView.identifier,
            withReuseIdentifier: PageIndicatorView.identifier
        )
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

        self.dataSource.configureSupplementaryView = { [unowned self] dataSource, collectionView, kind, indexPath in
            guard let indicator = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: PageIndicatorView.identifier, for: indexPath
            ) as? PageIndicatorView
            else { return UICollectionReusableView() }
            let totalCount = self.dataSource[indexPath.section].items.count
            indicator.bind(
                currentPage: self.pagingInfoSubject, section: indexPath.section, totalCount: totalCount
            )
            return indicator
        }

        let input = HomeViewModel.Input(
            loadMore: self.homeCollectionView
                .loadMore()
                .asDriverOnErrorJustComplete(),
            refresh: self.refreshControl.rx
                .controlEvent(.valueChanged)
                .asDriverOnErrorJustComplete(),
            like: self.likeGoodsViewModelSubject.asDriverOnErrorJustComplete()
        )
        let output = self.viewModel.transform(input: input)

        output.homeSectionModels.drive(self.homeCollectionView.rx.items(
            dataSource: self.dataSource)
        ).disposed(by: self.disposeBag)

        output.isRefreshing.drive(self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)

        output.events.drive()
            .disposed(by: self.disposeBag)
    }

}
