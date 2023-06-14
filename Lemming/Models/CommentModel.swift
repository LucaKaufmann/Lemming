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
    let timestamp: Date?
    let timestampDescription: String
    let user: String
    
    let child_count: Int
    let downvotes: Int
    let score: Int
    let upvotes: Int
    
    let my_vote: Int?
}
