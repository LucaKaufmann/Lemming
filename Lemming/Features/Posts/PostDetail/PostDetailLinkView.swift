//
//  PostDetailLinkView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 19.6.2023.
//

import SwiftUI

struct PostDetailLinkView: View {
    
    let thumbnailUrl: URL?
    let postUrl: URL
    
    var body: some View {
        Link(destination: postUrl) {
            HStack {
                if let thumbnailUrl {
                    ThumbnailView(thumbnailUrl: thumbnailUrl)
                        .frame(width: 60, height: 60, alignment: .center)
                        .padding(5)
                }
                Text(postUrl.absoluteString.replacingOccurrences(of: "https://", with: ""))
                    .lineLimit(1)
                    .padding()
                    .foregroundColor(Color.LemmingColors.text)
                Spacer()
                Image(systemName: "chevron.right")
                    .padding(.trailing)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("lemmingGray"))
        }
    }
}

struct PostDetailLinkView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailLinkView(thumbnailUrl: PostModel.mockPosts[2].thumbnail_url, postUrl: PostModel.mockPosts[2].url!)
    }
}
