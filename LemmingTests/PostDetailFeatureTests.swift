//
//  PostDetailFeatureTests.swift
//  LemmingTests
//
//  Created by Luca Kaufmann on 24.6.2023.
//

import XCTest
import ComposableArchitecture
@testable import Lemming

final class PostDetailFeatureTests: XCTestCase {
    
    let testStore = TestStore(initialState: PostDetailFeature.State(post: PostModel.mockPosts.first!, comments: [], isLoading: false), reducer: PostDetailFeature())
    
    func testBuildCommentGraph() async throws {

        await testStore.send(.buildCommentGraph(CommentModel.mockComments))
        let commentGraph: IdentifiedArrayOf<CommentDetailFeature.State> = [
            CommentDetailFeature.State(comment: CommentModel.mockComments[0], childComments: [
                CommentDetailFeature.State(comment: CommentModel.mockComments[1], childComments: [
                
                ]),
                CommentDetailFeature.State(comment: CommentModel.mockComments[2], childComments: [
                    CommentDetailFeature.State(comment: CommentModel.mockComments[3], childComments: [])
                ])
                
            ]),
            CommentDetailFeature.State(comment: CommentModel.mockComments[4], childComments: [
                CommentDetailFeature.State(comment: CommentModel.mockComments[5], childComments: []),
                CommentDetailFeature.State(comment: CommentModel.mockComments[6], childComments: []),
                CommentDetailFeature.State(comment: CommentModel.mockComments[7], childComments: []),
            ]),
            CommentDetailFeature.State(comment: CommentModel.mockComments[8], childComments: [])
        ]
        await testStore.receive(.updateComments(commentGraph)) {
            $0.comments = commentGraph
        }
    }
}


