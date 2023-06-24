//
//  PostDetailFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation
import ComposableArchitecture
//#if os(macOS)
//import Cocoa
//#else
//import UIKit
//#endif

struct PostDetailFeature: ReducerProtocol {
    
    @Dependency(\.commentService) var commentService
    @Dependency(\.accountService) var accountService
    
    struct State: Equatable {
        var post: PostModel
        var comments: IdentifiedArrayOf<CommentDetailFeature.State>
        
        var isLoading: Bool
    }
    
    enum Action: Equatable {
        case tappedUpvote
        case onAppear
        
        case buildCommentGraph([CommentModel])
        case updateComments(IdentifiedArrayOf<CommentDetailFeature.State>)
        case comment(id: CommentDetailFeature.State.ID, action: CommentDetailFeature.Action)
    }
    
    var body: some ReducerProtocolOf<PostDetailFeature> {
        Reduce { state, action in
            switch action {
                case .onAppear:
                    let postId = state.post.id
                    state.isLoading = true
                    return .task {
                        let comments = try await commentService.getComments(forPost: postId, sort: .hot, origin: .all, account: accountService.getCurrentAccount(), previewInstance: nil)
                        return .buildCommentGraph(comments)
                    }
                case .tappedUpvote:
                    return .none
                case .buildCommentGraph(let newComments):

                    return .task {
                        let updatedComments = await buildCommentGraph(newComments)
                        
                        return .updateComments(updatedComments)
                    }
                case .updateComments(let comments):
                    state.isLoading = false
                    state.comments = comments
                    return .none
                case .comment(_, _):
                    return .none
            }
        }.forEach(\.comments, action: /Action.comment) {
            CommentDetailFeature()
        }
    }
    
    func buildCommentGraph(_ comments: [CommentModel]) async -> IdentifiedArrayOf<CommentDetailFeature.State> {
        let rootComments = comments.filter({ $0.parents.isEmpty })
        
        var result = IdentifiedArrayOf<CommentDetailFeature.State>()
        
        for rootComment in rootComments {
            let childComments = await getChildComments(rootComment, from: comments)
            let newComment = CommentDetailFeature.State(comment: rootComment, childComments: childComments)
            result.append(newComment)
        }
        
        return result
    }
    
    func getChildComments(_ parentComment: CommentModel, from allComments: [CommentModel]) async -> IdentifiedArrayOf<CommentDetailFeature.State> {
        var children = IdentifiedArrayOf<CommentDetailFeature.State>()
        for comment in allComments.filter({ $0.parents.last == parentComment.id }) {
            let childComments = await getChildComments(comment, from: allComments)
            let newChildComment = CommentDetailFeature.State(comment: comment, childComments: childComments)
            
            children.append(newChildComment)
        }
        return children
    }
}
