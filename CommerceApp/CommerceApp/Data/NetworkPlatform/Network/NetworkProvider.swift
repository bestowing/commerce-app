//
//  NetworkProvider.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

final class NetworkProvider {

    // MARK: - properties

    private let apiEndPoint: String

    // MARK: - init/deinit

    init() {
        self.apiEndPoint = "http://d2bab9i9pr8lds.cloudfront.net/api"
    }

    // MARK: - methods

    func makeHomeNetwork() -> HomeNetwork {
        let homeNetworkAPI = self.apiEndPoint + "/home"
        let endPoints = HomeNetwork.EndPoint(
            homeDTO: homeNetworkAPI, goodsDTO: { lastGoodsID in
                return homeNetworkAPI + "/goods?lastId=\(lastGoodsID)"
            }
        )
        return HomeNetwork(endPoints: endPoints)
    }

}
