//
//  PostsRowView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import SwiftUI
import CachedAsyncImage

struct PostsRowView: View {
    
    let post: PostModel
    let showThumbnail: Bool
    
    let formatter = KMBFormatter()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Group {
                        if post.pinnedLocal {
                            Image(systemName: "pin.circle.fill")
                                .resizable()
                        } else if post.pinnedCommunity {
                            Image(systemName: "pin.circle")
                                .resizable()
                        }
                    }
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.LemmingColors.accentOpt3)
                    Text(LocalizedStringKey(post.title))
                    Spacer()
                }
                Spacer()
                HStack {
                    Text(post.communityName)
                    Text(post.timestampDescription)
                        .font(.caption)
                        .foregroundColor(Color("lemmingGrayDark"))
                    Spacer()
                        .frame(width: 25)
                    Text("\(formatter.string(for: post.numberOfUpvotes) ?? "") \(Image(systemName: IconConstants.upvote(post.my_vote == 1)))")
                    Text("\(formatter.string(for: post.numberOfComments) ?? "") \(Image(systemName: IconConstants.comment))")
                        .foregroundColor(Color.LemmingColors.primaryOnBackground)
                }
                .font(.footnote)
                .foregroundColor(Color("lemmingOrange"))
            }
            Spacer()
            if showThumbnail {
                ThumbnailView(thumbnailUrl: post.thumbnail_url)
                    .frame(width: 60, height: 60, alignment: .center)
            }
        }.padding(.vertical)
    }
}

struct ThumbnailView: View {
    
    let thumbnailUrl: URL?

    var body: some View {
        if let thumbnailUrl {
            CachedAsyncImage(url: thumbnailUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else if phase.error != nil {
                    TextPostThumbnail()
                } else {
                    ProgressView()
                }
            }
        } else {
            TextPostThumbnail()
                .padding(5)
        }
    }
}

struct TextPostThumbnail: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill()
            .overlay {
                Image(systemName: "text.alignleft")
                    .resizable()
                    .padding(10)
                    .foregroundColor(Color.LemmingColors.text)
            }
            .foregroundColor(Color("lemmingGray"))
            .opacity(0.3)
    }
}


struct PostsRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostsRowView(post: PostModel.mockPosts.first!, showThumbnail: false)
            .frame(height: 75)
            .background {
                Color.LemmingColors.background
            }
        PostsRowView(post: PostModel.mockPosts.first!, showThumbnail: true)
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
