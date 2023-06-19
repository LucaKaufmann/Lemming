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
                TabView(selection: viewStore.binding(send: RootFeature.Action.selectedTabChanged)) {
                    PostsRootFeatureView(store: store.scope(state: \.postsRoot, action: RootFeature.Action.posts))
                        .tabItem { Label("Posts", systemImage: "bubble.right.circle.fill")  }
                        .tag(RootFeature.Tab.posts)
                    
                    AccountFeatureView(store: store.scope(state: \.account, action: RootFeature.Action.account))
                        .tabItem { Label("Account", systemImage: "person.crop.circle.fill") }
                        .tag(RootFeature.Tab.account)
                    
                    Text("Search")
                        .tabItem { Label("Search", systemImage: "magnifyingglass.circle.fill")  }
                        .tag(RootFeature.Tab.search)
                    
                    Text("Settings")
                        .tabItem { Label("Settings", systemImage: "gearshape.circle.fill")  }
                        .tag(RootFeature.Tab.settings)
                }.accentColor(Color("lemmingOrange"))
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Store(initialState: RootFeature.State(postsRoot: .init(postsFeature: .init(posts: PostModel.mockPosts, currentPage: 0, isLoading: false, sort: .hot, origin: .all)),
                                                              account: .init(availableAccounts: []),
                                                              search: "search",
                                                              settings: "settings", isLoggedIn: false), reducer: RootFeature()._printChanges()))
        .previewDisplayName("Not logged in")

        RootView(store: Store(initialState: RootFeature.State(postsRoot: .init(postsFeature: .init(posts: PostModel.mockPosts, currentPage: 0, isLoading: false, sort: .hot, origin: .all)),
                                                              account: .init(availableAccounts: []),
                                                              search: "search",
                                                              settings: "settings", isLoggedIn: true), reducer: RootFeature()._printChanges()))
        .previewDisplayName("Logged in")
    }
}
