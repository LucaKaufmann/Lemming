//
//  CommentSheetFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 21.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct CommentSheetFeatureView: View {
    
    let store: StoreOf<CommentSheetFeature>
    
    var body: some View {
        NavigationView {
            WithViewStore(store, observe: { $0 }) { viewStore in
                VStack {
                    TextEditor(text: viewStore.binding(\.$commentText))
                }
                .padding()
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
                }
            }
        }
    }
}

struct CommentSheetFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        CommentSheetFeatureView(store: Store(initialState: CommentSheetFeature.State(post: PostModel.mockPosts.first!, commentText: ""), reducer: CommentSheetFeature()))
    }
}