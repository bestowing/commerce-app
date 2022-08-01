//
//  Network.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/30.
//

import Foundation
import RxAlamofire
import RxSwift

final class Network {

    struct EndPoint {
        let homeDTO: String
        let goodsDTO: (Int) -> String
    }

    // MARK: - properties

    private let endPoints: EndPoint
    private let scheduler: ConcurrentDispatchQueueScheduler

    // MARK: - init/deinit

    init(endPoints: EndPoint) {
        self.endPoints = endPoints
        self.scheduler = ConcurrentDispatchQueueScheduler(
            qos: DispatchQoS(
                qosClass: DispatchQoS.QoSClass.background, relativePriority: 1
            )
        )
    }

    // MARK: - methods

    func fetchHomeDTO() -> Observable<HomeDTO> {
        return RxAlamofire
            .data(.get, self.endPoints.homeDTO)
            .observe(on: scheduler)
            .map { data -> HomeDTO in
                return try JSONDecoder().decode(HomeDTO.self, from: data)
            }
    }

    func fetchGoodsDTO(after lastGoodsID: Int) -> Observable<GoodsDTO> {
        return RxAlamofire
            .data(.get, self.endPoints.goodsDTO(lastGoodsID))
            .observe(on: scheduler)
            .map { data -> GoodsDTO in
                return try JSONDecoder().decode(GoodsDTO.self, from: data)
            }
    }

}
