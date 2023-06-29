//
//  UserServiceDependency.swift
//  Lemming
//
//  Created by Luca Kaufmann on 28.6.2023.
//

import ComposableArchitecture

private enum UserServiceDependencyKey: DependencyKey {
    static let liveValue: UserService = LemmyUserService()
}

extension DependencyValues {
    var userService: UserService {
        get { self[UserServiceDependencyKey.self] }
        set { self[UserServiceDependencyKey.self] = newValue }
    }
}
