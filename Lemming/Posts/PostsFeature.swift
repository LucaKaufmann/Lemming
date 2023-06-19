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
    
    struct State: Equatable {
        var posts: [PostModel]
        var currentPage: Int
        var currentAccount: LemmingAccountModel?
        var isLoading: Bool
        
        @BindingState var sort: PostSortType
        @BindingState var origin: PostOriginType
    }
    
    enum Action: Equatable, BindableAction {
        case onAppear
        case refreshPosts
        case loadNextPage
        case appendPosts([PostModel])
        case updateWithPosts([PostModel])
        case tappedOnPost(PostModel)

        case delegate(Delegate)
        case binding(BindingAction<State>)
        
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
                    
                    if let account = state.currentAccount {
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
                    
                    if let account = state.currentAccount {
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
                case .updateWithPosts(let posts):
                    state.posts = posts
                    state.isLoading = false
                    return .none
                case .appendPosts(let posts):
                    guard !posts.isEmpty else {
                        return .none
                    }
                    state.posts.append(contentsOf: posts)
                    state.isLoading = false
                    state.currentPage += 1
                    return .none
                    
                case .tappedOnPost(let post):
                    return .send(.delegate(.goToPost(post)))
                case .delegate(_):
                    return .none
                case .binding(\.$sort), .binding(\.$origin):
                    return .send(.refreshPosts)
                case .binding(_):
                    return .none
            }
        }
    }
}
