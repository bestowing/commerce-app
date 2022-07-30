//
//  ErrorTracker.swift
//  CommerceApp
//
//  Created by 이청수 on 2022/07/31.
//

import Foundation
import RxCocoa
import RxSwift

final class ErrorTracker: SharedSequenceConvertibleType {

    typealias SharingStrategy = DriverSharingStrategy

    // MARK: - properties

    private let _subject = PublishSubject<Error>()

    // MARK: - init/deinit

    deinit {
        _subject.onCompleted()
    }

    // MARK: - methods

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

}

extension ObservableConvertibleType {

    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }

}
