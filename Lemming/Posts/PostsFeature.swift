//
//  PostsFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import ComposableArchitecture

struct PostsFeature: ReducerProtocol {
    struct State: Equatable {
        var posts: [PostModel]
    }
    
    enum Action: Equatable {
        case refreshPosts
        case updateWithPosts([PostModel])
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
