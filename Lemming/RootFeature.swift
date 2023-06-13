//
//  RootFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 11.6.2023.
//

import Foundation
import ComposableArchitecture

struct RootFeature: ReducerProtocol {
    
    enum Tab {
      case posts, account, search, settings
    }
    
    struct State: Equatable {
        var posts: PostsFeature.State
        var account: String
        var search: String
        var settings: String
        
        var selectedTab: Tab = .posts
    }
    
    enum Action: Equatable {
        case selectedTabChanged(Tab)
        case posts(PostsFeature.Action)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .selectedTabChanged(let tab):
                    state.selectedTab = tab
                    return .none
                default:
                    return .none
            }
        }
        Scope(state: \.posts, action: /Action.posts) {
            PostsFeature()
        }
    }
}
