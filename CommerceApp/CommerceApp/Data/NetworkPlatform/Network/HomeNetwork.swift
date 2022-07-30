//
//  HomeNetwork.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import Foundation
import RxAlamofire
import RxSwift

final class HomeNetwork {

    struct EndPoint {
        let homeDTO: String
        let goodsDTO: (Int) -> String
    }

    // MARK: - properties

    private let endPoints: EndPoint

    // MARK: - init/deinit

    init(endPoints: EndPoint) {
        self.endPoints = endPoints
    }

    // MARK: - methods

    func fetchHomeDTO() -> Observable<(HomeDTO)> {
        return RxAlamofire
            .data(.get, self.endPoints.homeDTO)
            .map { data -> HomeDTO in
                return try JSONDecoder().decode(HomeDTO.self, from: data)
            }
    }

    func fetchGoodsDTO(after lastGoodsID: Int) -> Observable<GoodsDTO> {
        return RxAlamofire
            .data(.get, self.endPoints.goodsDTO(lastGoodsID))
            .map { data -> GoodsDTO in
                return try JSONDecoder().decode(GoodsDTO.self, from: data)
            }
    }

}
