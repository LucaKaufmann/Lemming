//
//  AccountRootFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 18.6.2023.
//


//import ComposableArchitecture
//
//struct AccountRootFeature: ReducerProtocol {
//    
//    struct State: Equatable {
//        var path = StackState<Path.State>()
//        var account: AccountFeature.State
//    }
//    
//    enum Action: Equatable {
//        case path(StackAction<Path.State, Path.Action>)
//        case account(AccountFeature.Action)
//    }
//    
//    var body: some ReducerProtocolOf<Self> {
//        Reduce { state, action in
//            switch action {
//                case .account(let action):
//                    return .none
//                case .path(_):
//                    return .none
//            }
//        }.forEach(\.path, action: /Action.path) {
//            Path()
//        }
//        Scope(state: \.account, action: /Action.account) {
//            AccountFeature()
//        }
//    }
//    
//    struct Path: ReducerProtocol {
//        enum State: Equatable {
////            case accountPosts(PostDetailFeature.State)
//        }
//        enum Action: Equatable {
////            case detailPost(PostDetailFeature.Action)
//        }
//        var body: some ReducerProtocolOf<Self> {
////            Scope(state: /State.detailPost, action: /Action.detailPost) {
////                PostDetailFeature()
////            }
//        }
//    }
//}
