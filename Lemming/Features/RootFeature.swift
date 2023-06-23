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
        var postsRoot: PostsRootFeature.State
        var account: AccountFeature.State
        var search: String
        var settings: String
        
        var selectedTab: Tab = .posts
        var isLoggedIn: Bool
    }
    
    enum Action: Equatable {
        case selectedTabChanged(Tab)
        case posts(PostsRootFeature.Action)
        case account(AccountFeature.Action)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .selectedTabChanged(let tab):
                    state.selectedTab = tab
                    return .none
                case .account(.delegate(let action)):
                    switch action {
                        case .updateCurrentAccount(let account):
                            state.postsRoot.postsFeature.posts = []
                            return .none
                        default:
                            return .none
                    }
                default:
                    return .none
            }
        }
        Scope(state: \.postsRoot, action: /Action.posts) {
            PostsRootFeature()
        }
        Scope(state: \.account, action: /Action.account) {
            AccountFeature()
        }
    }
}
