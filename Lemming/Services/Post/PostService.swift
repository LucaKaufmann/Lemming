//
//  PostService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 13.6.2023.
//

import Foundation

enum PostSortType: String, CaseIterable, Codable {
    /// Posts sorted by hot, but bumped by new comments up to 2 days.
    case active = "Active"
    /// Posts sorted by a decaying rank.
    case hot = "Hot"
    /// Posts sorted by the most comments.
    case mostComments = "MostComments"
    /// Posts sorted by the published time.
    case new = "New"
    /// Posts sorted by the newest comments, with no necrobumping. IE a forum sort.
    case newComments = "NewComments"
    /// Posts sorted by the published time ascending
    case old = "Old"
    /// The top posts of all time.
    case topAll = "TopAll"
    /// The top posts for this last day.
    case topDay = "TopDay"
    /// The top posts for this last month.
    case topMonth = "TopMonth"
    /// The top posts for this last week.
    case topWeek = "TopWeek"
    /// The top posts for this last year.
    case topYear = "TopYear"
}

enum PostOriginType: String, CaseIterable, Codable {
    case all = "All"
    case community = "Community"
    case local = "Local"
    case subscribed = "Subscribed"
}

enum PostServiceError: Error {
    case instanceUrlError
}

protocol PostService {
    func getPosts(community_id: Int?, community_name: String?, page: Int, sort: PostSortType, origin: PostOriginType, account: LemmingAccountModel?, previewInstance: URL?) async throws -> [PostModel]
    
    func upvotePost(postId: Int, account: LemmingAccountModel) async throws -> PostModel
    func removeUpvoteFrom(postId: Int, account: LemmingAccountModel) async throws -> PostModel
    func downvotePost(postId: Int, account: LemmingAccountModel) async throws -> PostModel
}
