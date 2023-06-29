//
//  CommentDetailView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct CommentDetailView: View {
    
    @State var isExpanded = true
    
    let store: StoreOf<CommentDetailFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(LocalizedStringKey(viewStore.content))
                            .multilineTextAlignment(.leading)
                            .frame(minHeight: 40)
                        Spacer()
                    }
                #if os(iOS)
                    .addButtonActions(leadingButtons: [.upvote, .downvote],
                                      trailingButton:  [.reply], onClick: { button in
                        switch button {
                            case .upvote:
                                viewStore.send(.tappedUpvote)
                            case .downvote:
                                viewStore.send(.tappedDownvote)
                            case .reply:
                                
                            default:
                                break
                        }
                        print("clicked: \(button)")
                      })
                #endif
                    LazyVStack {
                        //                    ForEachStore(store) {
                        //                        
                        //                    }
                        ForEachStore(store.scope(state: \.childComments, action: CommentDetailFeature.Action.childComment)) { store in
                            HStack {
                                Rectangle()
                                    .fill(Color("primary"))
                                    .frame(width: 2, alignment: .center)
                                    .opacity(viewStore.child_count > 0 ? 1 : 0)
                                CommentDetailView(store: store)
                            }
                            .padding(.top)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewStore.user)
                        .foregroundColor(Color.LemmingColors.accentBeige)
                    Text(viewStore.timestampDescription)
                        .foregroundColor(Color.LemmingColors.accentGrayDark)
                    Spacer()
                    Text("\(Image(systemName: IconConstants.score)) \(viewStore.score)")
                        .foregroundColor(Color("lemmingOrange"))
                    Text("\(Image(systemName: IconConstants.upvote(viewStore.my_vote == 1))) \(viewStore.upvotes)")
                        .foregroundColor(Color("lemmingOrange"))
                    Text("\(Image(systemName: IconConstants.downvote(viewStore.my_vote == -1))) \(viewStore.downvotes)")
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
}

struct CommentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CommentDetailView(store: Store(initialState: .init(comment: CommentModel.mockComments.first!), reducer: CommentDetailFeature()))
        CommentDetailView(store: Store(initialState: .init(comment: CommentModel(id: 2, content: "This is a short comment", timestamp: Date(), timestampDescription: "3 min ago", user: "Testuser", path: "0", child_count: 0, downvotes: 50, score: 50, upvotes: 100, my_vote: 1, postId: 2, children: [])), reducer: CommentDetailFeature()))
    }
}
