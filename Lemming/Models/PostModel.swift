//
//  PostModel.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import Foundation

struct PostModel: Equatable, Identifiable, Codable {
    let id = UUID()
    
    let title: String
    let community: String
    let numberOfUpvotes: Int
    let numberOfComments: Int
    let timestamp: Date
    let user: String
    
    static var mockPosts: [PostModel] {
        let post1 = PostModel(title: "[Megathread] Reddit going dark", community: "lemmy", numberOfUpvotes: 420420, numberOfComments: 1337, timestamp: Date(), user: "Admin")
        let post2 = PostModel(title: "Another mock post", community: "swift", numberOfUpvotes: 123, numberOfComments: 1, timestamp: Date(), user: "Codable")
        let post3 = PostModel(title: "How are they so cute?", community: "lemmings", numberOfUpvotes: 1, numberOfComments: 0, timestamp: Date(), user: "LemmingFan123")
        
        return [post1, post2, post3]
    }
}
