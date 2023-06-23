//
//  CommentDetailView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import SwiftUI

struct CommentDetailView: View {
    
    @State var isExpanded = true
        
    let comment: CommentModel
    
    var body: some View {
//        Collapsible(header: {
//            HStack {
//                Text(comment.user)
//                    .foregroundColor(Color("lemmingGrayDark"))
//                Spacer()
//                Text("\(Image(systemName: IconConstants.score)) \(comment.score)")
//                    .foregroundColor(Color("lemmingOrange"))
//                Text("\(Image(systemName: IconConstants.upvote)) \(comment.upvotes)")
//                    .foregroundColor(Color("lemmingOrange"))
//                Text("\(Image(systemName: IconConstants.downvote)) \(comment.downvotes)")
//                    .foregroundColor(Color.LemmingColors.error)
//            }
//            .font(.caption)
//            .frame(height: 40)
//        }, content: {
//            VStack(alignment: .leading) {
//                Text(LocalizedStringKey(comment.content))
//                    .addButtonActions(leadingButtons: [.upvote, .downvote],
//                                      trailingButton:  [.reply], onClick: { button in
//                        print("clicked: \(button)")
//                    })
//                LazyVStack {
//                    ForEach(comment.children) { childComment in
//                        HStack {
//                            Rectangle()
//                                .fill(Color("primary"))
//                                .frame(width: 2, alignment: .center)
//                                .opacity(childComment.child_count > 0 ? 1 : 0)
//                            CommentDetailView(comment: childComment)
//                        }
//                        .padding(.top)
//                        
//                    }
//                }
//            }
//        })
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading) {
                Text(comment.content)
                    .multilineTextAlignment(.leading)
                    .frame(minHeight: 40)
                    .addButtonActions(leadingButtons: [.upvote, .downvote],
                                      trailingButton:  [.reply], onClick: { button in
                                        print("clicked: \(button)")
                                      })
                LazyVStack {
                    ForEach(comment.children) { childComment in
                        HStack {
                            Rectangle()
                                .fill(Color("primary"))
                                .frame(width: 2, alignment: .center)
                                .opacity(childComment.child_count > 0 ? 1 : 0)
                            CommentDetailView(comment: childComment)
                        }
                        .padding(.top)
                        
                    }
                }
            }
        } label: {
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
            }
            .font(.caption)
            .frame(height: 40)
            .contentShape(Rectangle())
            .onTapGesture {
                print("tap")
                isExpanded.toggle()
            }
        }.accentColor(Color("lemmingOrange"))
    }
}

struct CommentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CommentDetailView(comment: CommentModel(id: 1,
                                                content: "This is a test comment",
                                                timestamp: Date(),
                                                timestampDescription: "1h ago",
                                                user: "Codable",
                                                path: "",
                                                child_count: 3, downvotes: 0,
                                                score: 100,
                                                upvotes: 1,
                                                my_vote: nil,
                                                children: [
                                                    CommentModel(id: 2,
                                                                                            content: "This is a child test comment",
                                                                                            timestamp: Date(),
                                                                                            timestampDescription: "1h ago",
                                                                                            user: "Codable",
                                                                                            path: "",
                                                                                            child_count: 3, downvotes: 0,
                                                                                            score: 100,
                                                                                            upvotes: 1,
                                                                                            my_vote: nil,
                                                                                            children: [])
                                                
                                                ]))
    }
}
