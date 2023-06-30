//
//  SettingsRootFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 30.6.2023.
//

import Foundation
import ComposableArchitecture

struct SettingsRootFeature: ReducerProtocol {
    
    struct State: Equatable {
        @PresentationState var appIcon: AppIconFeature.State?
    }
    
    enum Action: Equatable {
        case tappedAppIcon
        // navigation
        case appIcon(PresentationAction<AppIconFeature.Action>)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .tappedAppIcon:
                    state.appIcon = .init(currentIcon: AppIconFeature.currentlySelectedIcon, icons: AppIcon.allCases)
                    return .none
                default:
                    return .none
            }
        }.ifLet(\.$appIcon, action: /Action.appIcon) {
            AppIconFeature()
        }
    }
}
