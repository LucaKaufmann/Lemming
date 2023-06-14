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
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: RootFeature.State(posts: .init(posts: PostModel.mockPosts, currentPage: 0, isLoading: false),
                                                                  account: "account",
                                                                  search: "search",
                                                                  settings: "settings"), reducer: RootFeature()._printChanges()))
        }
    }
}
