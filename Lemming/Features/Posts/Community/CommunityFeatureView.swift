//
//  CommunityFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 25.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct CommunityFeatureView: View {
    
    let store: StoreOf<CommunityFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                if let community = viewStore.community {
                    CommunityFeatureHeaderView(community: community)
                }
                ForEach(viewStore.posts) { post in
                    PostsRowView(post: post, showThumbnail: true)
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
            .sheet(store: store.scope(state: \.$commentSheet, action: CommunityFeature.Action.commentSheet)) { store in
                CommentSheetFeatureView(store: store)
            }
        }
    }
}

struct CommunityFeatureHeaderView: View {
    
    let community: CommunityModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(community.name)
            HStack(spacing: 15) {
                Text("\(Image(systemName: "person.3")) \(community.subscribers)")
                    .foregroundColor(Color.LemmingColors.accent)
                Text("\(Image(systemName: "calendar.circle")) \(community.users_active_month)")
                    .foregroundColor(Color.LemmingColors.accent)
                Spacer()
                Text("\(Image(systemName: "note.text")) \(community.posts)")
                    .foregroundColor(Color.LemmingColors.accent)
                Text("\(Image(systemName: "bubble.right.fill")) \(community.comments)")
                    .foregroundColor(Color.LemmingColors.comments)
            }.font(.footnote)
        }.listRowBackground(Color.clear)
    }
}

struct CommunityFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityFeatureView(store: Store(initialState: CommunityFeature.State(communityId: 1,
                                                                               community: CommunityModel.mockModels.first!,
                                                                               posts: IdentifiedArray(uniqueElements: PostModel.mockPosts),
                                                                               currentPage: 0,
                                                                               isLoading: false,
                                                                               sort: .hot),
                                          reducer: CommunityFeature()))
    }
}
