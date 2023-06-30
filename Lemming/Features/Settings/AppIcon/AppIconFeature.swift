//
//  AppIconFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 30.6.2023.
//

import Foundation
import ComposableArchitecture
import UIKit

struct AppIconFeature: ReducerProtocol {
    
    struct State: Equatable {
        var currentIcon: AppIcon
        var icons: [AppIcon]
    }
    
    enum Action: Equatable {
        case didSelectIcon(AppIcon)
        case appIconUpdated(AppIcon)
        case appIconFailed(AppIcon)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case .didSelectIcon(let icon):
                let previousIcon = state.currentIcon
                    return .task { @MainActor in
                        guard UIApplication.shared.alternateIconName != icon.iconName else {
                            return .appIconUpdated(icon)
                        }
                        
                        do {
                            try await UIApplication.shared.setAlternateIconName(icon.iconName)
                            return .appIconUpdated(icon)
                        } catch {
                            /// We're only logging the error here and not actively handling the app icon failure
                            /// since it's very unlikely to fail.
                            print("Updating icon to \(String(describing: icon.iconName)) failed.")
                            
                            /// Restore previous app icon
                            return .appIconFailed(previousIcon)
                        }
                    }
                case .appIconUpdated(let updatedIcon):
                    state.currentIcon = updatedIcon
                    return .none
                case .appIconFailed(_):
                    return .none
            }
        }
    }
    
    static var currentlySelectedIcon: AppIcon {
        if let iconName = UIApplication.shared.alternateIconName, let appIcon = AppIcon(rawValue: iconName) {
            return appIcon
        } else {
            return .standard
        }
    }
}
