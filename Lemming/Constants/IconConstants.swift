//
//  IconConstants.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation

enum IconConstants {
    static func upvote(_ upvoted: Bool) -> String {
        if upvoted {
            "arrowtriangle.up.fill"
        } else {
            "arrowtriangle.up"
        }
    }
    
    static func downvote(_ downvoted: Bool) -> String {
        if downvoted {
            "arrowtriangle.down.fill"
        } else {
            "arrowtriangle.down"
        }
    }
    static var upvote = "arrowtriangle.up"
    static var neutralVote = "arrowtriangle.left"
    static var downvote = "arrowtriangle.down"
    static var comment = "bubble.right"
    static var score = "flame"
}
