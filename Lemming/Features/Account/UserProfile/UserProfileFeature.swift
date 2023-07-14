//
//  UserProfileFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 28.6.2023.
//

import Foundation
import ComposableArchitecture

struct UserProfileFeature: ReducerProtocol {
    
    @Dependency(\.userService) var userService
    @Dependency(\.accountService) var accountService
    
    struct State: Equatable {
        var username: String?
        var userId: Int?
        var profile: UserProfileModel?
        
        var isLoading: Bool
        // child features
        var items: IdentifiedArrayOf<AnyUserProfileItem>
    }
    
    enum Action: Equatable {
        case onAppear
        case refreshProfile
        case userProfileUpdated(UserProfileModel)
        case userProfileItemsUpdated(IdentifiedArrayOf<AnyUserProfileItem>)
    }
    
    
    var body: some ReducerProtocol<State, Action> {
        Reduce(self.core)
    }
    
    private func core(state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            case .onAppear:
                return .send(.refreshProfile)
            case .refreshProfile:
                if let username = state.username {
                    state.isLoading = true
                    state.items = []
                    state.profile = nil
                    return .task {
                        let profile = try await userService.getUserDetails(userId: nil, username: username, page: 1, account: accountService.getCurrentAccount(), previewInstance: nil)
                        return .userProfileUpdated(profile)
                    }
                } else if let userId = state.userId {
                    state.isLoading = true
                    return .task {
                        let profile = try await userService.getUserDetails(userId: userId, username: nil, page: 1, account: accountService.getCurrentAccount(), previewInstance: nil)
                        return .userProfileUpdated(profile)
                    }
                } else {
                    return .none
                }
            case .userProfileUpdated(let profile):
                state.profile = profile
                state.isLoading = false

                return .task {
                    let profiles = await buildUserProfileItems(posts: profile.posts, comments: profile.comments)
                    return .userProfileItemsUpdated(profiles)
                }
            case .userProfileItemsUpdated(let items):
                state.items = items
                return .none
        }
    }
    
    private func buildUserProfileItems(posts: [PostModel], comments: [CommentModel]) async -> IdentifiedArrayOf<AnyUserProfileItem> {
        let postItems = posts.map {
            return AnyUserProfileItem(UserProfilePostItem(id: $0.id, timestamp: $0.timestamp, data: .init(post: $0, showThumbnail: true)))
        }
        
        let commentItems = comments.map {
            return AnyUserProfileItem(UserProfileCommentItem(id: $0.id,timestamp: $0.timestamp, data: .init(comment: $0)))
        }
        
        let combined = postItems + commentItems
        
        return IdentifiedArray(uniqueElements: combined.sorted(by: { $0.timestamp.compare($1.timestamp) == .orderedDescending }))
    }
}
