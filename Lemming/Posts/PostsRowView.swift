//
//  PostsRowView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import SwiftUI

struct PostsRowView: View {
    
    let post: PostModel
    let showThumbnail: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(post.title)
                Spacer()
                HStack {
                    Text(post.community)
                    Spacer()
                        .frame(minWidth: 50)
                    Text("\(post.numberOfUpvotes) \(Image(systemName: "arrowtriangle.up"))")
                    Text("\(post.numberOfComments) \(Image(systemName: "bubble.right"))")
                        .foregroundColor(Color.LemmingColors.primaryOnBackground)
                }
                .font(.footnote)
                .foregroundColor(Color("lemmingOrange"))
            }
            if showThumbnail {
                if let thumbnailUrl = post.thumbnail_url {
                    AsyncImage(url: thumbnailUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60, alignment: .center)
                                    .clipped()
                        } else if phase.error != nil {
                            Color.red
                        } else {
                            ProgressView()
                        }
                    }
                } else {
                    Spacer().frame(width: 75)
                }
            }
        }.padding()
    }
}


struct PostsRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostsRowView(post: PostModel.mockPosts.first!, showThumbnail: false)
            .frame(height: 75)
            .background {
                Color.LemmingColors.background
            }
        PostsRowView(post: PostModel.mockPosts[2], showThumbnail: true)
            .frame(height: 75)
            .background {
                Color.LemmingColors.background
            }
    }
}
