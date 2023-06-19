//
//  LemmyPostService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 13.6.2023.
//

import Foundation
import Lemmy_Swift_Client
import ComposableArchitecture

struct LemmyPostService: PostService {
    
    @Dependency(\.dateFormatterService) var dateFormatterService
    
    func getPosts(page: Int = 0, sort: PostSortType = .hot, origin: PostOriginType = .all, account: LemmingAccountModel?, previewInstance: URL?) async throws -> [PostModel] {
        guard let instanceUrl = URL(string: account?.instanceLink ?? "") ?? previewInstance else {
            throw PostServiceError.instanceUrlError
        }
        let api = LemmyAPI(baseUrl: instanceUrl.appending(path: "/api/v3"))

        let request = GetPostsRequest(auth: account?.jwt, page: page, sort: SortType(rawValue: sort.rawValue), type_: ListingType(rawValue: origin.rawValue))
        // Send the request to the Lemmy API
        do {
            let response = try await api.request(request)
            return response.posts.map { postView in
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
                                 community: postView.community.name,
                                 numberOfUpvotes: postView.counts.upvotes,
                                 numberOfComments: postView.counts.comments,
                                 timestamp: timestamp,
                                 timestampDescription: dateFormatterService.relativeDateTimeDescription(for: timestamp),
                                 user: postView.creator.name)
            }
        } catch {
            print("Lemmy error \(error)")
            return []
        }

    }
}
