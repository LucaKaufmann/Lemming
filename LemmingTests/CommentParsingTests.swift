//
//  CommentParsingTests.swift
//  LemmingTests
//
//  Created by Luca Kaufmann on 16.6.2023.
//

import XCTest
import ComposableArchitecture
@testable import Lemming

final class CommentParsingTests: XCTestCase {
    
    @Dependency(\.commentService) var commentService

    func testParseCommentNoParentIds() throws {
        let model = CommentModel(id: 1, content: "This is a test comment", timestamp: Date(), timestampDescription: "now", user: "Testuser", path: "0.1", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, children: [])
        
        XCTAssertEqual(model.parents, [])
    }
    
    func testParseCommentOneParentId() throws {
        let model = CommentModel(id: 2, content: "This is a test comment", timestamp: Date(), timestampDescription: "now", user: "Testuser", path: "0.1.2", child_count: 0, downvotes: 0, score: 0, upvotes: 0, my_vote: 0, children: [])
        
        XCTAssertEqual(model.parents, [1])
    }
}
