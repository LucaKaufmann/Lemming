//
//  PostDetailFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation
import ComposableArchitecture

struct PostDetailFeature: ReducerProtocol {
    
    @Dependency(\.commentService) var commentService
    
    struct State: Equatable {
        var post: PostModel
        var comments: [CommentModel]
    }
    
    enum Action: Equatable {
        case tappedUpvote
        case onAppear
        case updateComments([CommentModel])
    }
    
    var body: some ReducerProtocolOf<PostDetailFeature> {
        Reduce { state, action in
            switch action {
                case .onAppear:
                    let postId = state.post.id
                    return .task {
                        let comments = await commentService.getComments(forPost: postId)
                        return .updateComments(comments)
                    }
                case .tappedUpvote:
                    return .none
                case .updateComments(let comments):
                    state.comments = comments
                    return .none
            }
        }
    }
}
