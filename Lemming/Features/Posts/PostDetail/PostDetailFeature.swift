//
//  PostDetailFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation
import ComposableArchitecture
import UIKit

struct PostDetailFeature: ReducerProtocol {
    
    @Dependency(\.commentService) var commentService
    
    struct State: Equatable {
        var post: PostModel
        var comments: [CommentModel]
        
        var isLoading: Bool
    }
    
    enum Action: Equatable {
        case tappedUpvote
        case onAppear
        case openUrl(URL)
        
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
                        let comments = await commentService.getComments(forPost: postId, sort: .hot, origin: .all)
                        return .buildCommentGraph(comments)
                    }
                case .tappedUpvote:
                    return .none
                case .openUrl(let url):
                    UIApplication.shared.open(url)
                    return .none
                case .buildCommentGraph(let newComments):
                    let ids = state.comments.map { $0.id }
                    let combined = state.comments + newComments.filter({ !ids.contains($0.id) })

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