//
//  CommunityFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 25.6.2023.
//

import Foundation
import ComposableArchitecture

struct CommunityFeature: ReducerProtocol {
    
    @Dependency(\.communityService) var communityService
    @Dependency(\.accountService) var accountService
    @Dependency(\.postService) var postService
    
    struct State: Equatable {
        var communityId: Int
        var community: CommunityModel?
        
        var postsList: PostsListFeature.State
        
        @BindingState var sort: PostSortType
    }
    
    enum Action: Equatable, BindableAction {
        // User actions
        case followCommunity
        
        // View lifecycle actions
        case onAppear
        case updateCommunity(CommunityModel)
        
        // child features
        case postsList(PostsListFeature.Action)
        
        // Library
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocolOf<CommunityFeature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .followCommunity:
                    guard let account = accountService.getCurrentAccount(), let community = state.community else {
                        #warning("Handle error")
                        return .none
                    }
                    if community.subscribed {
                        return .task {
                            let updatedCommunity = try await communityService.subscribeToCommunity(id: community.id, follow: false, account: account)
                            return .updateCommunity(updatedCommunity)
                        }
                    } else {
                        return .task {
                            let updatedCommunity = try await communityService.subscribeToCommunity(id: community.id, follow: true, account: account)
                            return .updateCommunity(updatedCommunity)
                        }
                    }

                case .onAppear:
                    guard let account = accountService.getCurrentAccount() else {
                        #warning("Handle error")
                        return .none
                    }
                    return .task { [communityId = state.communityId] in
                        let community = try await communityService.getCommunity(id: communityId, name: nil, account: account, previewInstance: nil)
                        return .updateCommunity(community)
                    }
                case .updateCommunity(let community):
                    state.community = community
                    return .none
                case .postsList(_):
                    return .none
                case .binding(\.$sort):
                    state.postsList.sort = state.sort
                    return .send(.postsList(.refreshPosts))
                case .binding(_):
                    return .none
            }
        }
        Scope(state: \.postsList, action: /Action.postsList) {
            PostsListFeature()
        }
    }
}
