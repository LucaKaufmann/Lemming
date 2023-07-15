//
//  UserProfilePostItem.swift
//  Lemming
//
//  Created by Luca Kaufmann on 29.6.2023.
//

import SwiftUI

struct UserProfilePostItem: UserProfileItem {
    
    var id: Int
    var timestamp: Date
    
    struct Data: UserProfileItemData {
        var post: PostModel
        var showThumbnail: Bool
    }
    
    private struct Content: View {
        var data: Data
        
        var body: some View {
            PostsRowView(post: data.post, showThumbnail: data.showThumbnail)
        }
    }
    
    private struct LeadingActionContent: View {
        var body: some View {
            Button {
                print("Upvote item")
                //                                viewStore.send(.upvotePost(post))
            } label: {
                Label("Upvote", systemImage: IconConstants.upvote)
            }
            .tint(Color.LemmingColors.upvote)
        }
    }
    
    private struct TrailingActionContent: View {
        var body: some View {
            Button {
                //                                viewStore.send(.upvotePost(post))
            } label: {
                Label("Comment", systemImage: IconConstants.comment)
            }
            .tint(Color.LemmingColors.comments)
        }
    }
    
    func make() -> some View {
        Content(data: data)
    }
    
    func makeLeadingAction() -> some View {
        LeadingActionContent()
    }
    
    func makeTrailingAction() -> some View {
        TrailingActionContent()
    }
    
    
    
    var data: Data
    
}

struct UserProfilePostItem_Previews: PreviewProvider {
    
    static var previews: some View {
        UserProfilePostItem(id: 1, timestamp: .now, data: .init(post: PostModel.mockPosts.first!, showThumbnail: true)).make()
    }
}

