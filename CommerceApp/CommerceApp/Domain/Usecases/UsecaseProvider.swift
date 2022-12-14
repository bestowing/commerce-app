//
//  UsecaseProvider.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

protocol UsecaseProvider {

    func makeHomeUsecase() -> HomeUsecase
    func makeLikeUsecase() -> LikeUsecase

}
