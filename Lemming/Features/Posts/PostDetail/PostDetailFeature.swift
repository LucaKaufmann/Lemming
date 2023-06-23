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
        var comments: [CommentModel]
        
        var isLoading: Bool
    }
    
    enum Action: Equatable {
        case tappedUpvote
        case onAppear
        case upvoteComment(CommentModel)
        case removeUpvoteFromComment(CommentModel)
        case downvoteComment(CommentModel)
        
        case appendNewComment(CommentModel)
        case buildCommentGraph([CommentModel])
        case updateComments([CommentModel])
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
                case .upvoteComment(let comment):
                    guard let account = accountService.getCurrentAccount() else {
                        return .none
                    }
                    return .task {
                        let newComment = try await commentService.upvote(comment: comment, account: account)
                        
                        return .appendNewComment(newComment)
                    }
                case .removeUpvoteFromComment(let comment):
                    guard let account = accountService.getCurrentAccount() else {
                        return .none
                    }
                    return .task {
                        let newComment = try await commentService.removeUpvoteFrom(comment: comment, account: account)
                        return .appendNewComment(newComment)
                    }
                case .downvoteComment(let comment):
                    guard let account = accountService.getCurrentAccount() else {
                        return .none
                    }
                    return .task {
                        let newComment = try  await commentService.downvote(comment: comment, account: account)
                        return .appendNewComment(newComment)
                    }
                case .appendNewComment(let newComment):
                    var comments = state.comments
                    if let index = comments.firstIndex(where: { $0.id == newComment.id }) {
                        print("Removing comment at index \(index)")
                        comments.remove(at: index)
                    }
                    comments.append(newComment)
                    print("Appending new comment \(newComment)")
                    return .send(.buildCommentGraph(comments))
                case .buildCommentGraph(let newComments):
                    let ids = newComments.map { $0.id }
                    let combined = state.comments.filter({ !ids.contains($0.id) }) + newComments

                    return .task {
                        let updatedComments = await buildCommentGraph(combined)
                        
                        return .updateComments(updatedComments)
                    }
                case .updateComments(let comments):
                    state.isLoading = false
                    state.comments = comments
                    return .none
            }
        }
    }
    
    func buildCommentGraph(_ comments: [CommentModel]) async -> [CommentModel] {
        let rootComments = comments.filter({ $0.parents.isEmpty })
        
        var result = [CommentModel]()
        
        for rootComment in rootComments {
            var newComment = rootComment
            newComment.children = await getChildComments(newComment, from: comments)
            result.append(newComment)
        }
        
        return result
    }
    
    func getChildComments(_ parentComment: CommentModel, from allComments: [CommentModel]) async -> [CommentModel] {
        var children = [CommentModel]()
        for comment in allComments.filter({ $0.parents.last == parentComment.id }) {
            var newChildComment = comment
            let childComments = await getChildComments(newChildComment, from: allComments)
            newChildComment.children = childComments
            children.append(newChildComment)
        }
        return children
    }
}
