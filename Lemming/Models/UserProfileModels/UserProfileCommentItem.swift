//
//  UserProfileCommentItem.swift
//  Lemming
//
//  Created by Luca Kaufmann on 29.6.2023.
//

import SwiftUI

struct UserProfileCommentItem: UserProfileItem {
    
    var id: Int
    var timestamp: Date
    
    struct Data: UserProfileItemData {
        var comment: CommentModel
    }
    
    private struct Content: View {
        var data: Data
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(data.comment.user)
                        .foregroundColor(Color.LemmingColors.accentBeige)
                    Text(data.comment.timestampDescription)
                        .foregroundColor(Color.LemmingColors.accentGrayDark)
                    Spacer()
                    Text("\(Image(systemName: IconConstants.score)) \(data.comment.score)")
                        .foregroundColor(Color("lemmingOrange"))
                    Text("\(Image(systemName: IconConstants.upvote(data.comment.my_vote == 1))) \(data.comment.upvotes)")
                        .foregroundColor(Color("lemmingOrange"))
                    Text("\(Image(systemName: IconConstants.downvote(data.comment.my_vote == -1))) \(data.comment.downvotes)")
                        .foregroundColor(Color.LemmingColors.error)
                }
                .font(.caption)
//                .frame(height: 40)
                .contentShape(Rectangle())
                HStack {
                    Text(LocalizedStringKey(data.comment.content))
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 40)
                    Spacer()
                }
            }
        }
    }
    
    func make() -> some View {
        Content(data: data)
    }
    
    var data: Data
    
}

struct UserProfileCommentItem_Previews: PreviewProvider {
    
    static var previews: some View {
        UserProfileCommentItem(id: 1, timestamp: .now, data: .init(comment: CommentModel.mockComments.first!)).make()
    }
}


