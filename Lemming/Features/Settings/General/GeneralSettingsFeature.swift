//
//  GeneralSettingsFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 30.6.2023.
//

import Foundation
import ComposableArchitecture

struct GeneralSettingsFeature: ReducerProtocol {
    
    struct State: Equatable {
        @BindingState var postSorting: PostSortType
        @BindingState var blurNSFW: Bool
        @BindingState var postOrigin: PostOriginType
        @BindingState var commentSorting: _CommentSortType
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocolOf<GeneralSettingsFeature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .binding(\.$postSorting):
                    UserDefaults.standard.setValue(state.postSorting, forKey: UserDefaultsKeys.postSortingKey)
                    return .none
                case .binding(\.$blurNSFW):
                    UserDefaults.standard.setValue(state.blurNSFW, forKey: UserDefaultsKeys.blurNSFWKey)
                    return .none
                case .binding(\.$postOrigin):
                    UserDefaults.standard.setValue(state.postOrigin, forKey: UserDefaultsKeys.postOriginKey)
                    return .none
                case .binding(\.$commentSorting):
                    UserDefaults.standard.setValue(state.commentSorting, forKey: UserDefaultsKeys.commentSortingKey)
                    return .none
                case .binding(_):
                    return .none
            }
        }
    }
}
