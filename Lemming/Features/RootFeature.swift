//
//  RootFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 11.6.2023.
//

import Foundation
import ComposableArchitecture

struct RootFeature: ReducerProtocol {
    
    @Dependency(\.appSettings) var appSettings
    
    enum Tab {
      case posts, account, search, settings
    }
    
    struct State: Equatable {
        var postsRoot: PostsRootFeature.State
        var account: AccountFeature.State
        var settings: SettingsRootFeature.State
        
        var search: String
        
        var selectedTab: Tab = .posts
        var isLoggedIn: Bool
    }
    
    enum Action: Equatable {
        case initialSetup
        case selectedTabChanged(Tab)
        case posts(PostsRootFeature.Action)
        case account(AccountFeature.Action)
        case settings(SettingsRootFeature.Action)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .initialSetup:
                    appSettings.setInitialSettings()
                    return .none
                case .selectedTabChanged(let tab):
                    state.selectedTab = tab
                    return .none
                case .account(.delegate(let action)):
                    switch action {
                        case .updateCurrentAccount(_):
                            state.postsRoot.postsFeature.postsList.posts = []
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
        Scope(state: \.settings, action: /Action.settings) {
            SettingsRootFeature()
        }
    }
}
