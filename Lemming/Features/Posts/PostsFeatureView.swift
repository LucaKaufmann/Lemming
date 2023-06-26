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
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            PostsListFeatureView(store: self.store.scope(state: \.postsList, action: PostsFeature.Action.postsList))
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
        }
    }
}

struct PostsFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostsFeatureView(store: Store(initialState: PostsFeature.State(postsList: .init(posts: IdentifiedArray(uniqueElements: PostModel.mockPosts), currentPage: 0, isLoading: false, sort: .hot, origin: .all), sort: .hot, origin: .all), reducer: PostsFeature()))
        }
    }
}
