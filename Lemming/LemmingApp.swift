//
//  LemmingApp.swift
//  Lemming
//
//  Created by Luca Kaufmann on 11.6.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct LemmingApp: App {
    
    @Dependency(\.accountService) var accountService
    @Dependency(\.appSettings) var appSettings
    
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: RootFeature.State(postsRoot: .init(postsFeature: .init(postsList: .init(posts: [],
                                                                                                                        currentPage: 0,
                                                                                                                        isLoading: false,
                                                                                                                        sort: appSettings.getSetting(forKey: UserDefaultsKeys.postSortingKey) ?? .hot,
                                                                                                                        origin: appSettings.getSetting(forKey: UserDefaultsKeys.postOriginKey) ?? .all), sort: appSettings.getSetting(forKey: UserDefaultsKeys.postSortingKey) ?? .hot, origin: appSettings.getSetting(forKey: UserDefaultsKeys.postOriginKey) ?? .all)),
                                                                  account: .init(currentAccount: accountService.getCurrentAccount(), availableAccounts: accountService.getAccounts(), userProfile: .init(username: accountService.getCurrentAccount()?.id, isLoading: false, items: [])),
                                                                  settings: .init(), search: "search",
                                                                  isLoggedIn: false), reducer: RootFeature()))
        }
    }
}
