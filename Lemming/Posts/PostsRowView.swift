//
//  PostsRowView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import SwiftUI

struct PostsRowView: View {
    
    let post: PostModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(post.title)
                Spacer()
                HStack {
                    Text(post.community)
                    Spacer()
                        .frame(width: 50)
                    Text("\(post.numberOfUpvotes) \(Image(systemName: "arrowtriangle.up"))")
                    Text("\(post.numberOfComments) \(Image(systemName: "bubble.right"))")
                        .foregroundColor(Color.LemmingColors.primaryOnBackground)
                }
                .font(.footnote)
                .foregroundColor(Color("lemmingOrange"))
            }

            Spacer()
//                .frame(width: 75)
        }.padding()
    }
}


struct PostsRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostsRowView(post: PostModel.mockPosts.first!)
            .frame(height: 75)
            .background {
                Color.LemmingColors.background
            }
    }
}
