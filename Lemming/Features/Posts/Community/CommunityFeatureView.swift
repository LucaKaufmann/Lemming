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
            PostsListFeatureView(store: self.store.scope(state: \.postsList, action: CommunityFeature.Action.postsList))
                .background {
                    Color.LemmingColors.background.ignoresSafeArea()
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        if let community = viewStore.community {
                            Text(community.title)
                        } else {
                            ProgressView()
                        }
                        
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Menu("Community") {
                            Menu("Sorting") {
                                Picker("Sorting", selection: viewStore.binding(\.$sort)) {
                                    ForEach(PostSortType.allCases, id: \.self) { sortType in
                                        Text(sortType.rawValue)
                                            .tag(sortType)
                                    }
                                }
                            }
                            
                            Menu("Actions") {
                                Button(viewStore.community?.subscribed == true ? "Unfollow" : "Follow") {
                                    viewStore.send(.followCommunity)
                                }
                            }
                        }
                    }
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
                                                                               postsList: .init(posts: IdentifiedArray(uniqueElements: PostModel.mockPosts),
                                                                                                currentPage: 1,
                                                                                                isLoading: false,
                                                                                                sort: .hot,
                                                                                                origin: .all),
                                                                               sort: .hot),
                                          reducer: CommunityFeature()))
    }
}
