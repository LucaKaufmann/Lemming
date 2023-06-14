//
//  RootView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 11.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: StoreOf<RootFeature>
    
    var body: some View {
        ZStack {
            WithViewStore(self.store, observe: \.selectedTab) { viewStore in
                Color.red.ignoresSafeArea()
                TabView(selection: viewStore.binding(send: RootFeature.Action.selectedTabChanged)) {
                    PostsFeatureView(store: store.scope(state: \.posts, action: RootFeature.Action.posts))
                        .tabItem { Text("Posts") }
                        .tag(RootFeature.Tab.posts)
                    
                    Text("Account")
                        .tabItem { Text("Account") }
                        .tag(RootFeature.Tab.account)
                    
                    Text("Search")
                        .tabItem { Text("Search") }
                        .tag(RootFeature.Tab.search)
                    
                    Text("Settings")
                        .tabItem { Text("Settings") }
                        .tag(RootFeature.Tab.settings)
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Store(initialState: RootFeature.State(posts: .init(posts: PostModel.mockPosts, currentPage: 0, isLoading: false),
                                                              account: "account",
                                                              search: "search",
                                                              settings: "settings"), reducer: RootFeature()._printChanges()))
    }
}
