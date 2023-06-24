//
//  PostServiceDependency.swift
//  Lemming
//
//  Created by Luca Kaufmann on 13.6.2023.
//

import ComposableArchitecture

private enum PostServiceKey: DependencyKey {
    static let liveValue: PostService = LemmyPostService()
    static let testValue: PostService = LemmyPostService()
}

extension DependencyValues {
    var postService: PostService {
        get { self[PostServiceKey.self] }
        set { self[PostServiceKey.self] = newValue }
    }
}
