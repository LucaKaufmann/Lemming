//
//  LemmingDesignSystem.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import Foundation
import SwiftUI

extension Color {
    enum LemmingColors {
        
        public static var primary: Color {
            return Color("primaryColor")
        }
        
        public static var primaryOnBackground: Color {
            return Color("primaryOnBackground")
        }
        
        public static var secondary: Color {
            return Color("secondaryColor")
        }
        
        public static var background: Color {
            return Color("background")
        }
        
        public static var text: Color {
            return Color("text")
        }
        
        public static var error: Color {
            return Color("error")
        }
        
        public static var primaryButtonBackground: Color {
            return Color("primaryButtonBackground")
        }
        
        public static var primaryButtonText: Color {
            return Color("primaryButtonText")
        }
        
        public static var secondaryButtonBackground: Color {
            return Color("secondaryButtonBackground")
        }
        
        public static var secondaryButtonText: Color {
            return Color("secondaryButtonText")
        }
        
        public static var destructionButtonText: Color {
            return Color("destructionButtonText")
        }
        
        public static var destructionButtonBackground: Color {
            return Color("destructionButtonBackground")
        }
        
        
        /// User actions
        
        public static var comments: Color {
            return Color("lemmingBlue")
        }
        
        public static var upvote: Color {
            return Color("lemmingGreen")
        }
        
        public static var removeUpvote: Color {
            return Color("lemmingOrange")
        }
        
        public static var downvote: Color {
            return Color("lemmingPink")
        }
        
        // UI
        public static var accent: Color {
            return Color("lemmingOrange")
        }
        
    }
}
