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
        var postsList: PostsListFeature.State
        
        @BindingState var sort: PostSortType
        @BindingState var origin: PostOriginType
    }
    
    enum Action: Equatable, BindableAction {
        case postsList(PostsListFeature.Action)
        /// Library
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocolOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                /// Library
                case .postsList(_):
                    return .none
                case .binding(\.$sort), .binding(\.$origin):
                    state.postsList.sort = state.sort
                    state.postsList.origin = state.origin
                    return .send(.postsList(.refreshPosts))
                case .binding(_):
                    return .none
            }
        }
        Scope(state: \.postsList, action: /Action.postsList) {
            PostsListFeature()
        }
    }
}
