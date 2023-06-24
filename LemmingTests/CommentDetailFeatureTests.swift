//
//  CommentDetailFeatureTests.swift
//  LemmingTests
//
//  Created by Luca Kaufmann on 24.6.2023.
//

import XCTest
import ComposableArchitecture
@testable import Lemming

final class CommentDetailFeatureTests: XCTestCase {
    
    let model = CommentModel(id: 1, content: "This is a test comment", timestamp: Date(), timestampDescription: "now", user: "Testuser", path: "0.1", child_count: 2, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, children: [
        CommentModel(id: 2, content: "This is a test comment 2", timestamp: Date(), timestampDescription: "now", user: "Testuser", path: "0.1.2", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, children: []),
        CommentModel(id: 3, content: "This is a test comment 3", timestamp: Date(), timestampDescription: "now", user: "Testuser", path: "0.1.3", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, children: []),
    ])

    func testUpvote() async throws {
        let testStore = TestStore(initialState: CommentDetailFeature.State(comment: model, childComments: []), reducer: CommentDetailFeature())
        
        await testStore.send(.tappedUpvote) {
            $0.upvotes = 1
        }
        
        
        XCTAssertEqual(model.parents, [])
    }
    
    func testParseCommentOneParentId() throws {
        let model = CommentModel(id: 2, content: "This is a test comment", timestamp: Date(), timestampDescription: "now", user: "Testuser", path: "0.1.2", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, children: [])
        
        XCTAssertEqual(model.parents, [1])
    }
}

