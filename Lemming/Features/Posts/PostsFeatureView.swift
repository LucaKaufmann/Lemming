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
    
    struct ViewState: Equatable, Hashable {
        let posts: [PostModel]
        let isLoading: Bool
        let sort: PostSortType
        let origin: PostOriginType
        
        init(state: PostsFeature.State) {
            self.posts = state.posts.elements
            self.isLoading = state.isLoading
            self.sort = state.sort
            self.origin = state.origin
        }
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            PostsListView(store: store)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu("Settings") {
                        Menu("Sorting") {
                            Picker("Sorting", selection: viewStore.binding(\.$sort)) {
                                ForEach(PostSortType.allCases, id: \.self) { sortType in
                                    Text(sortType.rawValue)
                                        .tag(sortType)
                                }
                            }
                        }
                        Menu("Origin") {
                            Picker("Origin", selection: viewStore.binding(\.$origin)) {
                                ForEach(PostOriginType.allCases, id: \.self) { originType in
                                    Text(originType.rawValue)
                                        .tag(originType)
                                }
                            }
                        }
                    }
                }
            }
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
            .sheet(store: store.scope(state: \.$commentSheet, action: PostsFeature.Action.commentSheet)) { store in
                CommentSheetFeatureView(store: store)
            }
        }
    }
}

struct PostsListView: View {
    
    let store: StoreOf<PostsFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
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
                            .tint(Color("lemmingOrange"))
                        } else {
                            Button {
                                viewStore.send(.upvotePost(post))
                            } label: {
                                Label("Upvote", systemImage: IconConstants.upvote)
                            }
                            .tint(Color("lemmingGreen"))
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            viewStore.send(.commentOnPost(post))
                        } label: {
                            Label("Comment", systemImage: IconConstants.comment)
                        }
                        .tint(Color.LemmingColors.primary)
                    }
                }
                if viewStore.isLoading && viewStore.posts.count > 0 {
                    ProgressView()
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

struct PostsFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostsFeatureView(store: Store(initialState: PostsFeature.State(posts: IdentifiedArray(uniqueElements: PostModel.mockPosts), currentPage: 0, isLoading: false, sort: .hot, origin: .all), reducer: PostsFeature()))
        }
    }
}
