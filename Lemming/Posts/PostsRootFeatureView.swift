//
//  PostsRootFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct PostsRootFeatureView: View {
    
    let store: StoreOf<PostsRootFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            PostsFeatureView(store: store.scope(state: \.posts, action: PostsRootFeature.Action.posts))
            } destination: { state in
                switch state {
                    case .detailPost:
                        CaseLet(
                            state: /PostsRootFeature.Path.State.detailPost,
                            action: PostsRootFeature.Path.Action.detailPost,
                            then: PostDetailFeatureView.init(store:)
                        )
                }
            }

    }
}


struct PostsRootFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        PostsRootFeatureView(store: Store(initialState: .init(posts: PostsFeature.State(posts: PostModel.mockPosts, currentPage: 0, isLoading: false)), reducer: PostsRootFeature()))
    }
}