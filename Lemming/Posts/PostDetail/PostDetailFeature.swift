//
//  PostDetailFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation
import ComposableArchitecture

struct PostDetailFeature: ReducerProtocol {
    
    struct State: Equatable {
        var post: PostModel
    }
    
    enum Action: Equatable {
        case tappedUpvote
    }
    
    var body: some ReducerProtocolOf<PostDetailFeature> {
        Reduce { state, action in
            return .none
        }
    }
}
