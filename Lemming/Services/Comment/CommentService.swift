//
//  CommentService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation

enum _CommentSortType: String {
    /// Comments sorted by a decaying rank.
    case hot = "Hot"
    /// Comments sorted by new.
    case new = "New"
    /// Comments sorted by old.
    case old = "Old"
    /// Comments sorted by top score.
    case top = "Top"
}

enum CommentOriginType: String {
    case all = "All"
    case community = "Community"
    case local = "Local"
    case subscribed = "Subscribed"
}

enum CommentServiceError: Error {
    case instanceUrlError
}

protocol CommentService {
    func getComments(forPost postId: Int, sort: _CommentSortType, origin: CommentOriginType, account: LemmingAccountModel?, previewInstance: URL?) async throws -> [CommentModel]
    func postReplyTo(comment: CommentModel?, post: PostModel, replyText: String, account: LemmingAccountModel) async throws -> CommentModel
    
    func upvote(comment: CommentModel, post: PostModel, account: LemmingAccountModel) async throws -> PostModel
    func removeUpvoteFrom(comment: CommentModel, post: PostModel, account: LemmingAccountModel) async throws -> PostModel
    func downvote(comment: CommentModel, post: PostModel, account: LemmingAccountModel) async throws -> PostModel
}
