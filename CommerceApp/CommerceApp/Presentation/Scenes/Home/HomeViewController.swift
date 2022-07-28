//
//  HomeViewController.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

import SnapKit
import UIKit

final class HomeViewController: BaseViewController {

    // MARK: - properties

    var viewModel: HomeViewModel!

    private let goodsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.identifier)
        return collectionView
    }()

    // MARK: - init/deinit

    deinit {
        print("🗑", Self.description())
    }

    // MARK: - methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "홈"
        self.setSubViews()
    }

    private func setSubViews() {
        self.view.addSubview(self.goodsCollectionView)
        self.goodsCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

}
