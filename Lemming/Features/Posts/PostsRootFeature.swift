//
//  PostsRootFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import ComposableArchitecture

struct PostsRootFeature: ReducerProtocol {
    
    @Dependency(\.appSettings) var appSettings
    
    struct State: Equatable {
        var path = StackState<Path.State>()
        var postsFeature: PostsFeature.State
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case postsFeature(PostsFeature.Action)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .postsFeature(let action):
                    switch action {
                        case .postsList(.delegate(.goToPost(let post))):
                            state.path.append(.detailPost(.init(post: post, comments: [], isLoading: false)))
                            return .none
                        default:
                            break
                    }
                    return .none
                case let .path(.element(id: _, action: .detailPost(.delegate(action)))):
                    switch action {
                        case let .goToCommunity(communityId):
                            state.path.append(.community(.init(communityId: communityId,
                                                               postsList: .init(communityId: communityId,
                                                                                posts: [],
                                                                                currentPage: 1,
                                                                                isLoading: false,
                                                                                sort: appSettings.getSetting(forKey: UserDefaultsKeys.postSortingKey) ?? .hot,
                                                                                origin: appSettings.getSetting(forKey: UserDefaultsKeys.postOriginKey) ?? .all),
                                                               sort: .hot)))
                            return .none
                        case let .goToUser(userId):
                            state.path.append(.user(.init(userId: userId, isLoading: false, items: [])))
                            return .none
                    }
                case let .path(.element(id: _, action: .community(action))):
                    switch action {
                        case let .postsList(.delegate(.goToPost(post))):
                            state.path.append(.detailPost(.init(post: post, comments: [], isLoading: false)))
                            return .none
                        case let .postsList(.delegate(.goToUser(userId))):
                            state.path.append(.user(.init(userId: userId, isLoading: false, items: [])))
                            return .none
                        default:
                            return .none
                    }
                case .path(_):
                    return .none
            }
        }.forEach(\.path, action: /Action.path) {
            Path()
        }
        Scope(state: \.postsFeature, action: /Action.postsFeature) {
            PostsFeature()
        }
    }
    
    struct Path: ReducerProtocol {
        enum State: Equatable {
            case detailPost(PostDetailFeature.State)
            case community(CommunityFeature.State)
            case user(UserProfileFeature.State)
        }
        enum Action: Equatable {
            case detailPost(PostDetailFeature.Action)
            case community(CommunityFeature.Action)
            case user(UserProfileFeature.Action)
        }
        var body: some ReducerProtocolOf<Self> {
            Scope(state: /State.detailPost, action: /Action.detailPost) {
                PostDetailFeature()
            }
            Scope(state: /State.community, action: /Action.community) {
                CommunityFeature()
            }
            Scope(state: /State.user, action: /Action.user) {
                UserProfileFeature()
            }
        }
    }
}
