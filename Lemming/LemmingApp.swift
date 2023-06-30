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
    
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: RootFeature.State(postsRoot: .init(postsFeature: .init(postsList: .init(posts: [],
                                                                                                                        currentPage: 0,
                                                                                                                        isLoading: false,
                                                                                                                        sort: .hot,
                                                                                                                        origin: .all), sort: .hot, origin: .all)),
                                                                  account: .init(currentAccount: accountService.getCurrentAccount(), availableAccounts: accountService.getAccounts()),
                                                                  settings: .init(), search: "search",
                                                                  isLoggedIn: false), reducer: RootFeature()))
        }
    }
}
