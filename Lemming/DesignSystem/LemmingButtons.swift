//
//  LemmingButtons.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import SwiftUI

public struct LemmingButton: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public init(style: LemmingButton.Style, iconName: String? = nil) {
        self.style = style
        self.iconName = iconName
    }
    
    public enum Style {
        case primary, secondary, destruction
        case action(Action)
    }
    
    public enum Action {
        case upvote, downvote, comment
    }

    let style: Style
    let iconName: String?
    
    private let buttonPadding: CGFloat = 10
    private let cornerRadius: CGFloat = 12
    
    public func makeBody(configuration: Configuration) -> some View {
        switch style {
            case .primary:
                HStack {
                    if let iconName {
                        Image(systemName: iconName)
                    }
                    configuration.label
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundColor(Color.LemmingColors.primaryButtonText)
                .background(Color.LemmingColors.primaryButtonBackground)
                .cornerRadius(cornerRadius)
                .opacity(isEnabled ? 1 : 0.5)
                
            case .secondary:
                HStack {
                    if let iconName {
                        Image(systemName: iconName)
                    }
                    configuration.label
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundColor(Color.LemmingColors.secondaryButtonText)
                .background(Color.LemmingColors.secondaryButtonBackground)
                .cornerRadius(cornerRadius)
                .opacity(isEnabled ? 1 : 0.5)
                
            case .destruction:
                HStack {
                    if let iconName {
                        Image(systemName: iconName)
                    }
                    configuration.label
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundColor(Color.LemmingColors.destructionButtonText)
                .background(Color.LemmingColors.destructionButtonBackground)
                .cornerRadius(cornerRadius)
                .opacity(isEnabled ? 1 : 0.5)
            
            case .action(let action):
                switch action {
                    case .upvote:
                        HStack {
                            if let iconName {
                                Image(systemName: iconName)
                            }
                            configuration.label
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.LemmingColors.upvote)
                        .cornerRadius(cornerRadius)
                        .opacity(isEnabled ? 1 : 0.5)
                    case .downvote:
                        HStack {
                            if let iconName {
                                Image(systemName: iconName)
                            }
                            configuration.label
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.LemmingColors.downvote)
                        .cornerRadius(cornerRadius)
                        .opacity(isEnabled ? 1 : 0.5)
                    case .comment:
                        HStack {
                            if let iconName {
                                Image(systemName: iconName)
                            }
                            configuration.label
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.LemmingColors.comments)
                        .cornerRadius(cornerRadius)
                        .opacity(isEnabled ? 1 : 0.5)
                }
                
        }
    }
}

