//
//  LemmyCommentService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation
import Lemmy_Swift_Client
import ComposableArchitecture

struct LemmyCommentService: CommentService {
    
    @Dependency(\.dateFormatterService) var dateFormatterService
    
    func getComments(forPost postId: Int, sort: _CommentSortType = .hot, origin: CommentOriginType = .all, account: LemmingAccountModel?, previewInstance: URL?) async throws -> [CommentModel] {
        guard let instanceUrl = URL(string: account?.instanceLink ?? "") ?? previewInstance else {
            throw CommentServiceError.instanceUrlError
        }
        let request = GetCommentsRequest(max_depth: 15, post_id: postId, sort: CommentSortType(rawValue: sort.rawValue), type_: ListingType(rawValue: origin.rawValue))
        return await getCommentsFromRequest(request, instanceUrl: instanceUrl)
    }
    
    
    func postReplyTo(comment: CommentModel? = nil, post: PostModel, replyText: String, account: LemmingAccountModel) async throws -> CommentModel {
        guard let instanceUrl = URL(string: account.instanceLink) else {
            throw CommentServiceError.instanceUrlError
        }
        
        let request = CreateCommentRequest(auth: account.jwt, content: replyText, parent_id: comment?.id, post_id: post.id)
        let api = LemmyAPI(baseUrl: instanceUrl.appending(path: "/api/v3"))
        let response = try await api.request(request)
        
        return commentModelFrom(response.comment_view)
    }
    
    private func getCommentsFromRequest(_ request: GetCommentsRequest, instanceUrl: URL) async -> [CommentModel] {
        let api = LemmyAPI(baseUrl: instanceUrl.appending(path: "/api/v3"))
        do {
            let response = try await api.request(request)
            
            return response.comments.map { commentModelFrom($0) }
        } catch {
            print("Lemmy error \(error)")
            return []
        }
    }
    
    private func commentModelFrom(_ commentView: CommentView) -> CommentModel {
        let comment = commentView.comment
        let commentTimestamp = dateFormatterService.date(from: comment.published)
        return CommentModel(id: comment.id,
                           content: comment.content,
                           timestamp: commentTimestamp,
                           timestampDescription: dateFormatterService.relativeDateTimeDescription(for: commentTimestamp),
                           user: commentView.creator.name,
                           path: comment.path,
                           child_count: commentView.counts.child_count,
                           downvotes: commentView.counts.downvotes,
                           score: commentView.counts.score,
                           upvotes: commentView.counts.upvotes,
                           my_vote: commentView.my_vote,
                           children: [])
    }
    
}
