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
    @Dependency(\.postService) var postService
    
    struct State: Equatable {
        var post: PostModel
        var comments: IdentifiedArrayOf<CommentDetailFeature.State>
        
        var isLoading: Bool
        
        @PresentationState var commentSheet: CommentSheetFeature.State?
    }
    
    enum Action: Equatable {
        case tappedUpvote
        case tappedDownvote
        case tappedComment

        case onAppear
        case updatePost(PostModel)
        case updatePostFailed
        
        case buildCommentGraph([CommentModel])
        case updateComments(IdentifiedArrayOf<CommentDetailFeature.State>)
        case comment(id: CommentDetailFeature.State.ID, action: CommentDetailFeature.Action)
        
        /// Presentation
        case commentSheet(PresentationAction<CommentSheetFeature.Action>)
        
        // Delegate
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case goToCommunity(Int)
            case goToUser(Int)
        }
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
                
                // User action
                case .tappedUpvote:
                    guard let account = accountService.getCurrentAccount() else {
                        return .none
                    }
                    let post = state.post
                    if post.my_vote == 1 {
                        state.post.my_vote = 0
                        state.post.numberOfUpvotes -= 1
                        return .task {
                            do {
                                let updatedPost = try await postService.removeUpvoteFrom(postId: post.id, account: account)
                                return .updatePost(updatedPost)
                            } catch {
                                print("Error updating post \(error)")
                                return .updatePostFailed
                            }
                        }
                    } else {
                        state.post.my_vote = 1
                        state.post.numberOfUpvotes += 1
                        return .task {
                            do {
                                let updatedPost = try await postService.upvotePost(postId: post.id, account: account)
                                return .updatePost(updatedPost)
                            } catch {
                                print("Error updating post \(error)")
                                return .updatePostFailed
                            }
                        }
                    }
                case .tappedDownvote:
                    guard let account = accountService.getCurrentAccount() else {
                        return .none
                    }
                    let post = state.post
                    if post.my_vote == -1 {
                        state.post.my_vote = 0
                        state.post.numberOfUpvotes += 1
                        return .task {
                            do {
                                let updatedPost = try await postService.removeUpvoteFrom(postId: post.id, account: account)
                                return .updatePost(updatedPost)
                            } catch {
                                print("Error updating post \(error)")
                                return .updatePostFailed
                            }
                        }
                    } else {
                        state.post.my_vote = -1
                        state.post.numberOfUpvotes -= 1
                        return .task {
                            do {
                                let updatedPost = try await postService.downvotePost(postId: post.id, account: account)
                                return .updatePost(updatedPost)
                            } catch {
                                print("Error updating post \(error)")
                                return .updatePostFailed
                            }
                        }
                    }
                case .tappedComment:
                    state.commentSheet = .init(post: state.post, commentText: "")
                    return .none
                    
                case .updatePost(let post):
                    state.post = post
                    return .none
                case .updatePostFailed:
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
                    
                /// Presentation
                case .commentSheet(_):
                    return .none
                case .comment(_, _):
                    return .none
                case .delegate:
                    return .none
            }
        }.forEach(\.comments, action: /Action.comment) {
            CommentDetailFeature()
        }
        .ifLet(\.$commentSheet, action: /Action.commentSheet) {
            CommentSheetFeature()
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
