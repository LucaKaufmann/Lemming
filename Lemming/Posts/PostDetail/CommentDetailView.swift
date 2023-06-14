//
//  CommentDetailView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import SwiftUI

struct CommentDetailView: View {
    
    let comment: CommentModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(comment.user)
                    .foregroundColor(Color("lemmingGrayDark"))
                Spacer()
                Text("\(Image(systemName: IconConstants.score)) \(comment.score)")
                    .foregroundColor(Color("lemmingOrange"))
                Text("\(Image(systemName: IconConstants.upvote)) \(comment.upvotes)")
                    .foregroundColor(Color("lemmingOrange"))
                Text("\(Image(systemName: IconConstants.downvote)) \(comment.downvotes)")
                    .foregroundColor(Color.LemmingColors.error)
            }.font(.caption)
            Text(comment.content)
        }.padding()
    }
}

struct CommentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CommentDetailView(comment: CommentModel(id: 1, content: "This is a test comment", timestamp: Date(), timestampDescription: "1h ago", user: "Codable", child_count: 3, downvotes: 0, score: 100, upvotes: 1, my_vote: nil))
    }
}
