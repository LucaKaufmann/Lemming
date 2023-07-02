//
//  SettingsRootFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 30.6.2023.
//

import Foundation
import ComposableArchitecture

struct SettingsRootFeature: ReducerProtocol {
    
    @Dependency(\.appSettings) var appSettings
    
    struct State: Equatable {
        @PresentationState var appIcon: AppIconFeature.State?
        @PresentationState var generalSettings: GeneralSettingsFeature.State?
    }
    
    enum Action: Equatable {
        case tappedAppIcon
        case tappedGeneral
        // navigation
        case appIcon(PresentationAction<AppIconFeature.Action>)
        case generalSettings(PresentationAction<GeneralSettingsFeature.Action>)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .tappedAppIcon:
                    state.appIcon = .init(currentIcon: AppIconFeature.currentlySelectedIcon, icons: AppIcon.allCases)
                    return .none
                case .tappedGeneral:
                    state.generalSettings = .init(postSorting: appSettings.getSetting(forKey: UserDefaultsKeys.postSortingKey) ?? .hot,
                                                  blurNSFW: appSettings.getSetting(forKey: UserDefaultsKeys.blurNSFWKey) ?? true,
                                                  postOrigin: appSettings.getSetting(forKey: UserDefaultsKeys.postOriginKey) ?? .all,
                                                  commentSorting: appSettings.getSetting(forKey: UserDefaultsKeys.commentSortingKey) ?? .hot)
                    return .none
                default:
                    return .none
            }
        }.ifLet(\.$appIcon, action: /Action.appIcon) {
            AppIconFeature()
        }
        .ifLet(\.$generalSettings, action: /Action.generalSettings) {
            GeneralSettingsFeature()
        }
    }
}

