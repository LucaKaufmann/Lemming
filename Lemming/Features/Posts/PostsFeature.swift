//
//  PostsFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import Foundation
import ComposableArchitecture

struct PostsFeature: ReducerProtocol {
    
    @Dependency(\.postService) var postService
    @Dependency(\.accountService) var accountService
    
    struct State: Equatable {
        var posts: IdentifiedArrayOf<PostModel>
        var currentPage: Int
        var isLoading: Bool
        
        @BindingState var sort: PostSortType
        @BindingState var origin: PostOriginType
        
        @PresentationState var commentSheet: CommentSheetFeature.State?
    }
    
    enum Action: Equatable, BindableAction {
        case onAppear
        case refreshPosts
        case loadNextPage
        case appendPosts([PostModel])
        case updateWithPosts([PostModel])
        case updatePost(PostModel)
        case updatePostFailed(PostModel)
        
        /// User actions
        case tappedOnPost(PostModel)
        case upvotePost(PostModel)
        case commentOnPost(PostModel)

        /// Library
        case delegate(Delegate)
        case binding(BindingAction<State>)
        
        /// Presentation
        case commentSheet(PresentationAction<CommentSheetFeature.Action>)
        
        enum Delegate: Equatable {
          case goToPost(PostModel)
        }
    }
    
    var body: some ReducerProtocolOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .onAppear:
                    if state.posts.isEmpty {
                        return .send(.refreshPosts)
                    }
                    
                    return .none
                case .refreshPosts:
                    state.isLoading = true
                    state.currentPage = 1
                    
                    let sortingType = state.sort
                    let originType = state.origin
                    
                    if let account = accountService.getCurrentAccount() {
                        return .task {
                            let posts = try await postService.getPosts(page: 1,
                                                                   sort: sortingType,
                                                                   origin: originType,
                                                                   account: account,
                                                                   previewInstance: nil)
                            return .updateWithPosts(posts)
                        }
                    }
                    return .none
                case .loadNextPage:
                    state.isLoading = true
                    let page = state.currentPage + 1
                    let ids = state.posts.map { $0.id }
                    let sortingType = state.sort
                    let originType = state.origin
                    
                    if let account = accountService.getCurrentAccount() {
                        return .task {
                            let posts = try await postService.getPosts(page: page,
                                                                       sort: sortingType,
                                                                       origin: originType,
                                                                       account: account,
                                                                       previewInstance: nil)
                            let filteredPosts = posts.filter({ !ids.contains($0.id) })
                            return .appendPosts(filteredPosts)
                        }
                    }
                    return .none
                case .appendPosts(let posts):
                    guard !posts.isEmpty else {
                        return .none
                    }
                    state.posts.append(contentsOf: posts)
                    state.isLoading = false
                    state.currentPage += 1
                    return .none
                case .updateWithPosts(let posts):
                    state.posts = IdentifiedArray(uniqueElements: posts)
                    state.isLoading = false
                    return .none
                case .updatePost(let post):
                    state.posts[id: post.id] = post
                    return .none
                case .updatePostFailed(let post):
                    return .none
                    
                /// User actions
                case .tappedOnPost(let post):
                    return .send(.delegate(.goToPost(post)))
                case .upvotePost(let post):
                    guard let account = accountService.getCurrentAccount() else {
                        return .none
                    }
                    if post.my_vote == 1 {
                        return .task {
                            do {
                                let updatedPost = try await postService.removeUpvoteFrom(postId: post.id, account: account)
                                return .updatePost(updatedPost)
                            } catch {
                                print("Error updating post \(error)")
                                return .updatePostFailed(post)
                            }
                        }
                    } else {
                        return .task {
                            do {
                                let updatedPost = try await postService.upvotePost(postId: post.id, account: account)
                                return .updatePost(updatedPost)
                            } catch {
                                print("Error updating post \(error)")
                                return .updatePostFailed(post)
                            }
                        }
                    }
                case .commentOnPost(let post):
                    state.commentSheet = .init(post: post, commentText: "")
                    return .none
                    
                /// Library
                case .delegate(_):
                    return .none
                case .binding(\.$sort), .binding(\.$origin):
                    return .send(.refreshPosts)
                case .binding(_):
                    return .none
                    
                /// Presentation
                case .commentSheet(_):
                    return .none
            }
        }.ifLet(\.$commentSheet, action: /Action.commentSheet) {
            CommentSheetFeature()
        }
    }
}
