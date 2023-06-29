//
//  CommentModel.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation

struct CommentModel: Equatable, Identifiable, Hashable {
    let id: Int
    let content: String
    let timestamp: Date
    let timestampDescription: String
    let user: String
    
    let path: String
    
    let child_count: Int
    let downvotes: Int
    let score: Int
    let upvotes: Int
    
    let my_vote: Int?
    
    let postId: Int
    
    var children: [CommentModel]
    
    var parents: [Int] {
        return path
            .components(separatedBy: ".")
            .filter({ $0 != "0" && Int($0) != id })
            .compactMap({ Int($0) })
    }
    
    static var mockComments: [CommentModel] {
        return [
            .init(id: 1, content: "First parent comment", timestamp: Date(), timestampDescription: "", user: "Codable", path: "0.1", child_count: 2, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, postId: 1, children: []),
            .init(id: 4, content: "First child comment", timestamp: Date(), timestampDescription: "", user: "", path: "0.1.4", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, postId: 1, children: []),
            .init(id: 5, content: "Second child comment", timestamp: Date(), timestampDescription: "", user: "", path: "0.1.5", child_count: 1, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, postId: 1, children: []),
            .init(id: 9, content: "First second level child comment", timestamp: Date(), timestampDescription: "", user: "", path: "0.1.5.9", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, postId: 1, children: []),
            .init(id: 2, content: "Second parent comment", timestamp: Date(), timestampDescription: "", user: "", path: "0.2", child_count: 3, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, postId: 1, children: []),
            .init(id: 6, content: "Third child comment", timestamp: Date(), timestampDescription: "", user: "", path: "0.2.6", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, postId: 1, children: []),
            .init(id: 7, content: "Fourth child comment", timestamp: Date(), timestampDescription: "", user: "", path: "0.2.7", child_count: 1, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, postId: 1, children: []),
            .init(id: 8, content: "Fifth child comment", timestamp: Date(), timestampDescription: "", user: "", path: "0.2.8", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, postId: 1, children: []),
            .init(id: 3, content: "Third parent comment", timestamp: Date(), timestampDescription: "", user: "", path: "0.3", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, postId: 1, children: []),
        ]
    }
}
