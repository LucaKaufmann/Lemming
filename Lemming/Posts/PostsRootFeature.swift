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
        var postsFeature: PostsFeature.State
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)

        case postsFeature(PostsFeature.Action)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .postsFeature(let action):
                    switch action {
                        case .delegate(.goToPost(let post)):
                            state.path.append(.detailPost(.init(post: post, comments: [], isLoading: false)))
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
        Scope(state: \.postsFeature, action: /Action.postsFeature) {
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
