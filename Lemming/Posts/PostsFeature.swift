//
//  PostsFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import ComposableArchitecture

struct PostsFeature: ReducerProtocol {
    
    @Dependency(\.postService) var postService
    
    struct State: Equatable {
        var posts: [PostModel]
        var currentPage: Int
        var isLoading: Bool
    }
    
    enum Action: Equatable {
        case refreshPosts
        case loadNextPage
        case appendPosts([PostModel])
        case updateWithPosts([PostModel])
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .refreshPosts:
                    state.isLoading = true
                    state.currentPage = 1
                    return .task {
                        let posts = await postService.getPosts(page: 1)
                        return .updateWithPosts(posts)
                    }
                case .loadNextPage:
                    state.isLoading = true
                    let page = state.currentPage + 1
                    let ids = state.posts.map { $0.id }
                    return .task {
                        let posts = await postService.getPosts(page: page)
                        let filteredPosts = posts.filter({ !ids.contains($0.id) })
                        return .appendPosts(filteredPosts)
                    }
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
            }
        }
    }
}
