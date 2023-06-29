//
//  UserModel.swift
//  Lemming
//
//  Created by Luca Kaufmann on 28.6.2023.
//

import Foundation

struct UserProfileModel: Equatable {
    let user: UserModel
    let posts: [PostModel]
    let comments: [CommentModel]
    
    static var mockUser: UserProfileModel {
        let user = UserModel(id: 1, name: "Codable", avatar: "https://files.mastodon.social/accounts/avatars/109/470/986/562/003/009/original/2b07994710f51a8e.png", banner: "https://files.mastodon.social/accounts/headers/109/470/986/562/003/009/original/2298fee9fff218d2.png", displayName: "Codable", bio: "Some user bio", created: Date(), createdDescription: "now", comment_count: 3, comment_score: 3, post_count: 3, post_score: 3)
        return UserProfileModel(user: user, posts: PostModel.mockPosts, comments: CommentModel.mockComments)
    }
}

struct UserModel: Equatable {
    let id: Int
    let name: String
    let avatar: String?
    let banner: String?
    let displayName: String?
    let bio: String?
    let created: Date
    var createdDescription: String
    
    // aggregates
    let comment_count: Int
    let comment_score: Int
    let post_count: Int
    let post_score: Int
    
    static var mockUser: UserModel {
        return UserModel(id: 1, name: "Codable", avatar: "https://files.mastodon.social/accounts/avatars/109/470/986/562/003/009/original/2b07994710f51a8e.png", banner: "https://files.mastodon.social/accounts/headers/109/470/986/562/003/009/original/2298fee9fff218d2.png", displayName: "Codable", bio: "Some user bio", created: Date(), createdDescription: "now", comment_count: 101010101, comment_score: 3000, post_count: 10000, post_score: 1234567)
    }
}
