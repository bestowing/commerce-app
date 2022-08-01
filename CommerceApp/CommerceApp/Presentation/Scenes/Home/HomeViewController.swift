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

    typealias HomeDataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>

    // MARK: - properties

    var viewModel: HomeViewModel!

    private let likeGoodsViewModelSubject = PublishSubject<GoodsItemViewModel>()
    private let pagingInfoSubject = PublishSubject<PagingInfo>()

    private let refreshControl = UIRefreshControl()

    private lazy var homeDataSource = HomeDataSource(
        configureCell: { _, collectionView, indexPath, item in
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
        },
        configureSupplementaryView: { [unowned self] dataSource, collectionView, kind, indexPath in
            guard let indicatorView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PageIndicatorView.identifier,
                for: indexPath
            ) as? PageIndicatorView
            else { return UICollectionReusableView() }
            let totalCount = dataSource[indexPath.section].items.count
            indicatorView.bind(
                currentPage: self.pagingInfoSubject,
                section: indexPath.section,
                totalCount: totalCount
            )
            return indicatorView
        }
    )

    private lazy var homeLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            switch HomeSectionModel.section(from: sectionIndex) {
            case .BannerSection(_):
                let bannerLayout = self.bannerSectionLayout
                bannerLayout.visibleItemsInvalidationHandler = { [unowned self] (_, offset, _) in
                    let page = Int(round(offset.x / self.view.bounds.width))
                    self.pagingInfoSubject.onNext(
                        PagingInfo(section: sectionIndex, currentPage: page)
                    )
                }
                return bannerLayout
            case .GoodsSection(_):
                return self.goodsSectionLayout
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
        return layout
    }()

    private lazy var homeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: self.homeLayout
        )
        collectionView.isUserInteractionEnabled = true
        collectionView.refreshControl = self.refreshControl
        collectionView.register(
            BannerCell.self,
            forCellWithReuseIdentifier: BannerCell.identifier
        )
        collectionView.register(
            LikeEnabledGoodsCell.self,
            forCellWithReuseIdentifier: LikeEnabledGoodsCell.identifier
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
        self.title = "홈"
        self.setSubViews()
        self.bindViewModel()
        super.viewDidLoad()
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
            viewDidLoad: self.viewDidLoadTrigger
                .asDriverOnErrorJustComplete(),
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
            dataSource: self.homeDataSource)
        ).disposed(by: self.disposeBag)

        output.isRefreshing.drive(self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)

        output.events.drive()
            .disposed(by: self.disposeBag)
    }

}

extension HomeViewController {

    private var bannerSectionLayout: NSCollectionLayoutSection {
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
        let indicatorView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: indicatorSize, elementKind: PageIndicatorView.identifier, containerAnchor: itemAnchor
        )
        indicatorView.pinToVisibleBounds = true
        indicatorView.zIndex = 2
        section.boundarySupplementaryItems = [indicatorView]
        return section
    }

    private var goodsSectionLayout: NSCollectionLayoutSection {
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
    }

}
