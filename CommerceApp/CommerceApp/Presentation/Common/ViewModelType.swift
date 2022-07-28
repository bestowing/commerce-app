//
//  ViewModelType.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/28.
//

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output

}
