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
        var posts: IdentifiedArrayOf<PostModel>
        var currentPage: Int
        var isLoading: Bool
        
        @BindingState var sort: PostSortType
        
        @PresentationState var commentSheet: CommentSheetFeature.State?
    }
    
    enum Action: Equatable, BindableAction {
        // User actions
        case followCommunity
        case refreshPosts
        case loadNextPage
        
        // View lifecycle actions
        case onAppear
        case updateCommunity(CommunityModel)
        case updateData(posts: [PostModel]?, community: CommunityModel?)
        case appendPosts([PostModel])
        
        // Library
        case binding(BindingAction<State>)
        
        /// Presentation
        case commentSheet(PresentationAction<CommentSheetFeature.Action>)
    }
    
    var body: some ReducerProtocolOf<CommunityFeature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .followCommunity:
                    guard let account = accountService.getCurrentAccount() else {
                        #warning("Handle error")
                        return .none
                    }
                    return .task { [communityId = state.communityId] in
                        let updatedCommunity = try await communityService.subscribeToCommunity(id: communityId, follow: true, account: account)
                        return .updateCommunity(updatedCommunity)
                    }
                case .refreshPosts:
                    state.currentPage = 1
                                        
                    if let account = accountService.getCurrentAccount() {
                        return .task { [communityId = state.communityId, sort = state.sort] in
                            let posts = try await postService.getPosts(community_id: communityId,
                                                                       community_name: nil,
                                                                       page: 1,
                                                                       sort: sort,
                                                                       origin: .all,
                                                                       account: account,
                                                                       previewInstance: nil)
                            return .updateData(posts: posts, community: nil)
                        }
                    }
                    return .none
                case .loadNextPage:
                    state.isLoading = true
                    let page = state.currentPage + 1
                    let ids = state.posts.map { $0.id }
                    let sortingType = state.sort

                    
                    if let account = accountService.getCurrentAccount() {
                        return .task { [communityId = state.communityId] in
                            let posts = try await postService.getPosts(community_id: communityId,
                                                                       community_name: nil,
                                                                       page: page,
                                                                       sort: sortingType,
                                                                       origin: .all,
                                                                       account: account,
                                                                       previewInstance: nil)
                            let filteredPosts = posts.filter({ !ids.contains($0.id) })
                            return .appendPosts(filteredPosts)
                        }
                    }
                    return .none
                case .appendPosts(let posts):
                    guard !posts.isEmpty else {
                        return .none
                    }
                    state.posts.append(contentsOf: posts)
                    state.isLoading = false
                    state.currentPage += 1
                    return .none
                case .onAppear:
                    guard let account = accountService.getCurrentAccount() else {
                        #warning("Handle error")
                        return .none
                    }
                    return .task { [communityId = state.communityId, sort = state.sort] in
                        async let community = try communityService.getCommunity(id: communityId, name: nil, account: account, previewInstance: nil)
                        
                        async let posts = try await postService.getPosts(community_id: communityId,
                                                                              community_name: nil,
                                                                              page: 1,
                                                                              sort: sort,
                                                                         origin: .all,
                                                                              account: account,
                                                                              previewInstance: nil)
                        return .updateData(posts: try await posts, community: try await community)
                    }
                case .updateCommunity(let community):
                    state.community = community
                    return .none
                case .updateData(let posts, let community):
                    if let posts {
                        state.posts = IdentifiedArray(uniqueElements: posts)
                    }
                    if let community {
                        state.community = community
                    }
                    return .none
                case .binding(\.$sort):
                    return .send(.refreshPosts)
                case .binding(_):
                    return .none
                case .commentSheet(_):
                    return .none
            }
        }
    }
}
