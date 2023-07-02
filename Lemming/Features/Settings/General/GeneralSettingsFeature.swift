//
//  GeneralSettingsFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 30.6.2023.
//

import Foundation
import ComposableArchitecture

struct GeneralSettingsFeature: ReducerProtocol {
    
    @Dependency(\.appSettings) var appSettings
    
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
                    appSettings.setSetting(forKey: UserDefaultsKeys.postSortingKey, value: state.postSorting)
                    return .none
                case .binding(\.$blurNSFW):
                    appSettings.setSetting(forKey: UserDefaultsKeys.blurNSFWKey, value: state.blurNSFW)
                    return .none
                case .binding(\.$postOrigin):
                    appSettings.setSetting(forKey: UserDefaultsKeys.postOriginKey, value: state.postOrigin)
                    return .none
                case .binding(\.$commentSorting):
                    appSettings.setSetting(forKey: UserDefaultsKeys.commentSortingKey, value: state.commentSorting)
                    return .none
                case .binding(_):
                    return .none
            }
        }
    }
}
