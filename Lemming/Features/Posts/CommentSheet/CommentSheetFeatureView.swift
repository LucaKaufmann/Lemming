//
//  CommentSheetFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 21.6.2023.
//

import SwiftUI
import ComposableArchitecture
import CachedAsyncImage

struct CommentSheetFeatureView: View {
    enum FocusedField {
        case textEditor
    }
    
    @FocusState private var focusedField: FocusedField?

    let store: StoreOf<CommentSheetFeature>
    
    var body: some View {
        NavigationView {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ScrollView {
                    VStack(alignment: .leading) {

                        TextEditor(text: viewStore.binding(\.$commentText))
                            .focused($focusedField, equals: .textEditor)
                            .frame(minHeight: 150)
                        if viewStore.post != nil || viewStore.comment != nil {
                            Text("\(Image(systemName: "arrowshape.turn.up.left.fill")) Replying to ")
                                .font(.footnote)
                                .foregroundColor(Color.LemmingColors.accentBeige)
                            Divider()
                            if let post = viewStore.post {
                                CommentSheetPostPreview(post: post)
                            } else if let comment = viewStore.comment {
                                UserProfileCommentItem(id: comment.id, timestamp: comment.timestamp, data: .init(comment: comment)).make()
                            }
                        }
                    }
                }
                .padding()
                .onAppear {
                    focusedField = .textEditor
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.dismissTapped)
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button("Post") {
                            viewStore.send(.submitButtonTapped)
                        }
                    }
                }.accentColor(Color.LemmingColors.accent)
            }
        }
    }
}

struct CommentSheetPostPreview: View {
    
    let post: PostModel
    
    var body: some View {
        VStack {
            PostDetailHeaderView(post: post)
//                .padding(.horizontal)
            Divider()
            if let postUrl = post.url {
                if postUrl.isImage {
                    CachedAsyncImage(url: postUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if phase.error != nil {
                            Color.red
                        } else {
                            ProgressView()
                        }
                    }
                } else {
                    PostDetailLinkView(thumbnailUrl: post.thumbnail_url, postUrl: postUrl)
                        .padding()
                }
            }
            if let body = post.body {
                Text(LocalizedStringKey(body)).padding()
            }
        }
    }
}

struct CommentSheetFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        CommentSheetFeatureView(store: Store(initialState: CommentSheetFeature.State(post: PostModel.mockPosts.first!, commentText: ""), reducer: CommentSheetFeature()))
    }
}
