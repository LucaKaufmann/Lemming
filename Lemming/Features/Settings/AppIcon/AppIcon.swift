//
//  AppIcon.swift
//  Lemming
//
//  Created by Luca Kaufmann on 30.6.2023.
//

import Foundation
import UIKit

enum AppIcon: String, CaseIterable, Identifiable {
    case standard = "lemming-appicon-1"
    case minimal = "lemming-appicon-2"
    case stripes = "lemming-appicon-stripes"
    case lemmingApp = "lemming-appicon-3"
    case winter = "lemming-appicon-4"
    case summer = "lemming-appicon-5"
    case mountains = "lemming-appicon-6"
    case stripesPowerup = "lemming-appicon-stripes-2"

    var id: String { rawValue }
    var iconName: String? {
        switch self {
        case .standard:
            /// `nil` is used to reset the app icon back to its primary icon.
            return nil
        default:
            return rawValue
        }
    }

    var description: String {
        switch self {
        case .standard:
            return "Default"
            case .minimal:
                return "Minimal"
            case .lemmingApp:
                return "Lemming"
            case .winter:
                return "Winter"
            case .summer:
                return "Summer"
            case .mountains:
                return "Mountains"
            case .stripesPowerup:
                return "Stripes powerup"
            case .stripes:
                return "Stripes"
        }
    }

    var preview: UIImage {
        UIImage(named: rawValue) ?? UIImage()
    }
}
