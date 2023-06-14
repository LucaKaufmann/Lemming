//
//  CommentServiceDependency.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import ComposableArchitecture

private enum CommentServiceKey: DependencyKey {
    static let liveValue: CommentService = LemmyCommentService()
}

extension DependencyValues {
    var commentService: CommentService {
        get { self[CommentServiceKey.self] }
        set { self[CommentServiceKey.self] = newValue }
    }
}

