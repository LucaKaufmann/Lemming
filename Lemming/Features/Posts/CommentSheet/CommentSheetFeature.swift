//
//  CommentSheetFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 21.6.2023.
//

import Foundation
import ComposableArchitecture

struct CommentSheetFeature: ReducerProtocol {
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.commentService) var commentService
    @Dependency(\.accountService) var accountService
    
    struct State: Equatable {
        var post: PostModel
        var comment: CommentModel?
        
        @BindingState var commentText: String
    }
    
    enum Action: Equatable, BindableAction {
        case submitButtonTapped
        case dismissTapped
        case commentSuccessful
        case commentFailed
        
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocolOf<CommentSheetFeature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .submitButtonTapped:
                    guard let account = accountService.getCurrentAccount()
                    else {
                        return .none
                    }

                    let replyText = state.commentText
                    let post = state.post
                    return .task {
                        let _ = try await commentService.postReplyTo(commentId: nil, postId: post.id, replyText: replyText, account: account)
                        return .commentSuccessful
                    }
                case .commentSuccessful:
                    return .fireAndForget {
                        await dismiss()
                    }
                case .commentFailed:
                    return .none
                case .dismissTapped:
                    return .fireAndForget {
                        await dismiss()
                    }
                case .binding(_):
                    return .none
            }
        }
    }
}
