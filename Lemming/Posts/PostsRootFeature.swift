//
//  PostsRootFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import ComposableArchitecture

struct PostsRootFeature: ReducerProtocol {
    
    
    struct State: Equatable {
        var path = StackState<Path.State>()
        var posts: PostsFeature.State
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)

        case posts(PostsFeature.Action)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .posts(let action):
                    switch action {
                        case .delegate(.goToPost(let post)):
                            state.path.append(.detailPost(.init(post: post, currentPage: 1, comments: [], isLoading: false)))
                            return .none
                        default:
                            break
                    }
                    return .none
                case .path(_):
                    return .none
            }
        }.forEach(\.path, action: /Action.path) {
            Path()
        }
        Scope(state: \.posts, action: /Action.posts) {
            PostsFeature()
        }
    }
    
    struct Path: ReducerProtocol {
        enum State: Equatable {
            case detailPost(PostDetailFeature.State)
        }
        enum Action: Equatable {
            case detailPost(PostDetailFeature.Action)
        }
        var body: some ReducerProtocolOf<Self> {
            Scope(state: /State.detailPost, action: /Action.detailPost) {
                PostDetailFeature()
            }
        }
    }
}
