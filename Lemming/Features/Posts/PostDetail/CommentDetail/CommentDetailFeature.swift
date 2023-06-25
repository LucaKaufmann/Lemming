//
//  CommentDetailFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation
import ComposableArchitecture

struct CommentDetailFeature: ReducerProtocol {
    
    @Dependency(\.commentService) var commentService
    @Dependency(\.accountService) var accountService
    
    struct State: Equatable, Identifiable {
        var id: Int
        var content: String
        var timestamp: Date?
        var timestampDescription: String
        var user: String
        
        var path: String
        
        var child_count: Int
        var downvotes: Int
        var score: Int
        var upvotes: Int
        
        var my_vote: Int?
        var childComments: IdentifiedArrayOf<CommentDetailFeature.State>
        
        init(comment: CommentModel, childComments: IdentifiedArrayOf<CommentDetailFeature.State> = []) {
            self.id = comment.id
            self.content = comment.content
            self.timestamp = comment.timestamp
            self.timestampDescription = comment.timestampDescription
            self.user = comment.user
            self.path = comment.path
            self.child_count = comment.child_count
            self.downvotes = comment.downvotes
            self.score = comment.score
            self.upvotes = comment.upvotes
            self.my_vote = comment.my_vote
            self.childComments = childComments
        }
    }
    
    indirect enum Action: Equatable {
        case tappedUpvote
        case tappedDownvote
        case replyToComment
        case updateComment(CommentModel)
        case childComment(id: CommentDetailFeature.State.ID, action: Action)
    }
    
    var body: some ReducerProtocolOf<CommentDetailFeature> {
        Reduce { state, action in
            switch action {
                case .tappedUpvote:
                    guard let account = accountService.getCurrentAccount() else {
                        return .none
                    }
                    let id = state.id
                    if state.my_vote == 1 {
                        state.my_vote = 0
                        return .task {
                            let newComment = try await commentService.removeUpvoteFrom(commentId: id, account: account)
                            
                            return .updateComment(newComment)
                        }
                    } else {
                        state.my_vote = 1
                        return .task {
                            let newComment = try await commentService.upvote(commentId: id, account: account)
                            
                            return .updateComment(newComment)
                        }
                    }
                case .tappedDownvote:
                    guard let account = accountService.getCurrentAccount() else {
                        return .none
                    }
                    let id = state.id
                    if state.my_vote == -1 {
                        state.my_vote = 0
                        return .task {
                            let newComment = try await commentService.removeUpvoteFrom(commentId: id, account: account)
                            
                            return .updateComment(newComment)
                        }
                    } else {
                        state.my_vote = -1
                        return .task {
                            let newComment = try await commentService.downvote(commentId: id, account: account)
                            
                            return .updateComment(newComment)
                        }
                    }
                case .replyToComment:
                    return .none
                case .updateComment(let comment):
                    let childComments = state.childComments
                    state = State(comment: comment, childComments: childComments)
                    return .none
                case .childComment(_):
                    return .none
            }
        }.forEach(\.childComments, action: /Action.childComment) {
            CommentDetailFeature()
        }
    }
}
