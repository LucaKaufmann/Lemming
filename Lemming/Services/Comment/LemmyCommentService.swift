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
    
    func getComments(forPost postId: Int, sort: _CommentSortType = .hot, origin: CommentOriginType = .all) async -> [CommentModel] {
        let request = GetCommentsRequest(max_depth: 15, post_id: postId, sort: CommentSortType(rawValue: sort.rawValue), type_: ListingType(rawValue: origin.rawValue))
        return await getCommentsFromRequest(request)
    }
    
    private func getCommentsFromRequest(_ request: GetCommentsRequest) async -> [CommentModel] {
        let api = LemmyAPI(baseUrl: URL(string: "https://lemmy.ml/api/v3")!)
        do {
            let response = try await api.request(request)
            return response.comments.map { commentView in
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
        } catch {
            print("Lemmy error \(error)")
            return []
        }
    }
}
