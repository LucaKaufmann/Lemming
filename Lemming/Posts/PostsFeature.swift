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
    }
    
    enum Action: Equatable {
        case refreshPosts
        case updateWithPosts([PostModel])
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .refreshPosts:
                    return .task {
                        let posts = await postService.getPosts()
                        return .updateWithPosts(posts)
                    }
                case .updateWithPosts(let posts):
                    state.posts = posts
                    return .none
            }
        }
    }
}
