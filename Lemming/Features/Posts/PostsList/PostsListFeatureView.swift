//
//  PostsListFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 26.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct PostsListFeatureView: View {
    
    let store: StoreOf<PostsListFeature>
    
    struct ViewState: Equatable, Hashable {
        let posts: [PostModel]
        let isLoading: Bool
        
        init(state: PostsListFeature.State) {
            self.posts = state.posts.elements
            self.isLoading = state.isLoading
        }
    }
    
    var body: some View {
        WithViewStore(store, observe: ViewState.init) { viewStore in
            PostsListFeatureListView(store: store)
            .refreshable {
                viewStore.send(.refreshPosts)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .overlay {
                if viewStore.isLoading && viewStore.posts.count == 0 {
                    ProgressView()
                }
            }
            .sheet(store: store.scope(state: \.$commentSheet, action: PostsListFeature.Action.commentSheet)) { store in
                CommentSheetFeatureView(store: store)
            }
        }
    }
}

struct PostsListFeatureListView: View {
    
    let store: StoreOf<PostsListFeature>
    
    struct ViewState: Equatable, Hashable {
        let posts: [PostModel]
        let isLoading: Bool
        
        init(state: PostsListFeature.State) {
            self.posts = state.posts.elements
            self.isLoading = state.isLoading
        }
    }
    
    var body: some View {
        WithViewStore(store, observe: ViewState.init) { viewStore in
            List {
                ForEach(Array(viewStore.posts.enumerated()), id: \.element) { index, post in
                    Button(action: {
                        viewStore.send(.tappedOnPost(post))
                    }, label: {
                        PostsRowView(post: post, showThumbnail: true)
                            .contentShape(Rectangle())
                            .onAppear {
                                if index == viewStore.posts.count - 3 && !viewStore.isLoading {
                                    viewStore.send(.loadNextPage)
                                }
                            }
                    })
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .leading) {
                        if post.my_vote == 1 {
                            Button {
                                viewStore.send(.upvotePost(post))
                            } label: {
                                Label("Remove upvote", systemImage: IconConstants.neutralVote)
                            }
                            .tint(Color.LemmingColors.removeUpvote)
                        } else {
                            Button {
                                viewStore.send(.upvotePost(post))
                            } label: {
                                Label("Upvote", systemImage: IconConstants.upvote)
                            }
                            .tint(Color.LemmingColors.upvote)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            viewStore.send(.commentOnPost(post))
                        } label: {
                            Label("Comment", systemImage: IconConstants.comment)
                        }
                        .tint(Color.LemmingColors.comments)
                    }
                }
                if viewStore.isLoading && viewStore.posts.count > 0 {
                    ProgressView()
                        .listRowBackground(Color.clear)
                }
            }
            .background {
                #if os(xrOS)
                Color
                    .LemmingColors
                    .background
                    .opacity(0.5)
                    .ignoresSafeArea()
                #else
                Color
                    .LemmingColors
                    .background
                    .ignoresSafeArea()
                #endif
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
    }
}

struct PostsListFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostsListFeatureView(store: Store(initialState: PostsListFeature.State(posts: IdentifiedArray(uniqueElements: PostModel.mockPosts), currentPage: 0, isLoading: false, sort: .hot, origin: .all), reducer: PostsListFeature()))
        }
    }
}

