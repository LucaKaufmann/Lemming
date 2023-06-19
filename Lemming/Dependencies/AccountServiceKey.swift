//
//  AccountServiceKey.swift
//  Lemming
//
//  Created by Luca Kaufmann on 18.6.2023.
//

import ComposableArchitecture

private enum AccountServiceKey: DependencyKey {
    static let liveValue: AccountService = LemmyAccountService()
}

extension DependencyValues {
    var accountService: AccountService {
        get { self[AccountServiceKey.self] }
        set { self[AccountServiceKey.self] = newValue }
    }
}

