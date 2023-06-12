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
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                LazyVStack {
                    ForEach(viewStore.posts) { post in
                        PostsRowView(post: post)
                        Divider()
                    }
                }
            }
        }
    }
}

struct PostsFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        PostsFeatureView(store: Store(initialState: PostsFeature.State(posts: PostModel.mockPosts), reducer: PostsFeature()))
    }
}
