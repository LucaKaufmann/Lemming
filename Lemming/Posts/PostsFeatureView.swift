//
//  PostsFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct PostsFeatureView: View {
    
    let store: StoreOf<PostsFeature>
    
    struct ViewState: Equatable {
        let posts: [PostModel]
        let isLoading: Bool
        
        init(state: PostsFeature.State) {
            self.posts = state.posts
            self.isLoading = state.isLoading
        }
    }
    
    var body: some View {
        WithViewStore(store, observe: ViewState.init ) { viewStore in
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        ForEach(Array(viewStore.posts.enumerated()), id: \.element) { index, post in
                            PostsRowView(post: post)
                                .onAppear {
                                    if index == viewStore.posts.count - 3 && !viewStore.isLoading {
                                        viewStore.send(.loadNextPage)
                                    }
                                }
                            Divider()
                        }
                    }
                }.background {
                    Color.LemmingColors.background.ignoresSafeArea()
                }
                .onAppear {
                    viewStore.send(.refreshPosts)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Refresh") {
                            viewStore.send(.refreshPosts)
                        }
                    }
                }
            }
        }
    }
}

struct PostsFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        PostsFeatureView(store: Store(initialState: PostsFeature.State(posts: PostModel.mockPosts, currentPage: 0, isLoading: false), reducer: PostsFeature()))
    }
}
