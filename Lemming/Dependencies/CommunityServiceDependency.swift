//
//  CommunityServiceDependency.swift
//  Lemming
//
//  Created by Luca Kaufmann on 25.6.2023.
//

import ComposableArchitecture

private enum CommunityServiceKey: DependencyKey {
    static let liveValue: CommunityService = LemmyCommunityService()
    static let testValue: CommunityService = LemmyCommunityService()
}

extension DependencyValues {
    var communityService: CommunityService {
        get { self[CommunityServiceKey.self] }
        set { self[CommunityServiceKey.self] = newValue }
    }
}
