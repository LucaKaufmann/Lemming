//
//  LemmyUserService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 28.6.2023.
//

import Foundation
import Lemmy_Swift_Client
import ComposableArchitecture

struct LemmyUserService: UserService {
    
    @Dependency(\.dateFormatterService) var dateFormatterService
    
    func getUserDetails(userId: Int?, username: String?, page: Int, account: LemmingAccountModel?, previewInstance: URL?) async throws -> UserProfileModel {
        guard let instanceUrl = URL(string: account?.instanceLink ?? "") ?? previewInstance else {
            throw PostServiceError.instanceUrlError
        }
        let api = LemmyAPI(baseUrl: instanceUrl.appending(path: "/api/v3"))

        let request = GetPersonDetailsRequest(auth: account?.jwt, page: page, person_id: userId, username: username)
        
        // Send the request to the Lemmy API
        do {
            let response = try await api.request(request)
            let person = response.person_view.person
            let counts = response.person_view.counts
            let createdTimestamp = dateFormatterService.date(from: person.published)
            let userModel = UserModel(id: person.id,
                                      name: person.name,
                                      avatar: person.avatar,
                                      banner: person.banner,
                                      displayName: person.display_name,
                                      bio: person.bio,
                                      created: createdTimestamp ?? .now,
                                      createdDescription: dateFormatterService.relativeDateTimeDescription(for: createdTimestamp),
                                      comment_count: counts.comment_count,
                                      comment_score: counts.comment_score,
                                      post_count: counts.post_count,
                                      post_score: counts.post_score)
            
            let comments = response.comments.map { commentView in
                let comment = commentView.comment
                let commentTimestamp = dateFormatterService.date(from: comment.published)
                return CommentModel(id: comment.id,
                                   content: comment.content,
                                    timestamp: commentTimestamp ?? .now,
                                   timestampDescription: dateFormatterService.relativeDateTimeDescription(for: commentTimestamp),
                                   user: commentView.creator.name,
                                   path: comment.path,
                                   child_count: commentView.counts.child_count,
                                   downvotes: commentView.counts.downvotes,
                                   score: commentView.counts.score,
                                   upvotes: commentView.counts.upvotes,
                                   my_vote: commentView.my_vote,
                                    postId: comment.post_id,
                                   children: [])
            }
            
            let posts = response.posts.map { postView in
                let post = postView.post
                let timestamp = dateFormatterService.date(from: post.published)
                return PostModel(id: post.id,
                                 title: post.name,
                                 body: post.body,
                                 embed_description: post.embed_description,
                                 embed_title: post.embed_title,
                                 embed_video_url: URL(string: post.embed_video_url ?? ""),
                                 thumbnail_url: URL(string: post.thumbnail_url ?? ""),
                                 url: URL(string: post.url ?? ""),
                                 communityId: postView.community.id,
                                 communityName: postView.community.name,
                                 numberOfUpvotes: postView.counts.upvotes,
                                 numberOfComments: postView.counts.comments,
                                 my_vote: postView.my_vote,
                                 timestamp: timestamp ?? Date(),
                                 timestampDescription: dateFormatterService.relativeDateTimeDescription(for: timestamp),
                                 user: postView.creator.name,
                                 userId: postView.creator.id,
                                 pinnedLocal: postView.post.featured_local, pinnedCommunity: postView.post.featured_community)
            }
            
            return UserProfileModel(user: userModel, posts: posts, comments: comments)
        }
    }
    
}
