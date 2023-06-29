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
        
        var comment: CommentModel
        var childComments: IdentifiedArrayOf<CommentDetailFeature.State>
        
        @PresentationState var commentSheet: CommentSheetFeature.State?
        
        init(comment: CommentModel, childComments: IdentifiedArrayOf<CommentDetailFeature.State> = []) {
            self.id = comment.id
            self.comment = comment
            self.childComments = childComments
        }
    }
    
    indirect enum Action: Equatable {
        case tappedUpvote
        case tappedDownvote
        case replyToComment
        case updateComment(CommentModel)
        case childComment(id: CommentDetailFeature.State.ID, action: Action)
        
        /// Presentation
        case commentSheet(PresentationAction<CommentSheetFeature.Action>)
    }
    
    var body: some ReducerProtocolOf<CommentDetailFeature> {
        Reduce { state, action in
            switch action {
                case .tappedUpvote:
                    guard let account = accountService.getCurrentAccount() else {
                        return .none
                    }
                    let id = state.id
                    if state.comment.my_vote == 1 {
                        state.comment.my_vote = 0
                        return .task {
                            let newComment = try await commentService.removeUpvoteFrom(commentId: id, account: account)
                            
                            return .updateComment(newComment)
                        }
                    } else {
                        state.comment.my_vote = 1
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
                    if state.comment.my_vote == -1 {
                        state.comment.my_vote = 0
                        return .task {
                            let newComment = try await commentService.removeUpvoteFrom(commentId: id, account: account)
                            
                            return .updateComment(newComment)
                        }
                    } else {
                        state.comment.my_vote = -1
                        return .task {
                            let newComment = try await commentService.downvote(commentId: id, account: account)
                            
                            return .updateComment(newComment)
                        }
                    }
                case .replyToComment:
                    state.commentSheet = .init(comment: state.comment, commentText: "")
                    return .none
                case .updateComment(let comment):
                    let childComments = state.childComments
                    state = State(comment: comment, childComments: childComments)
                    return .none
                    
                /// Presentation
                case .commentSheet(_):
                    return .none
                    
                // Child features
                case .childComment(_):
                    return .none
            }
        }
        .ifLet(\.$commentSheet, action: /Action.commentSheet) {
            CommentSheetFeature()
        }
        .forEach(\.childComments, action: /Action.childComment) {
            CommentDetailFeature()
        }
    }
}
