//
//  UserProfileItem.swift
//  Lemming
//
//  Created by Luca Kaufmann on 29.6.2023.
//

import SwiftUI

typealias UserProfileItemKind = String

protocol UserProfileItemData: Hashable {}

protocol UserProfileItem {
    
    /// SwiftUI View
    associatedtype ViewBody: View
    associatedtype LeadingViewBody: View
    associatedtype TrailingViewBody: View

    
    /// Payload required to initialize the card
    associatedtype Data: UserProfileItemData

    var id: Int { get }
    var timestamp: Date { get }
    var data: Data { get }
    func make() -> ViewBody
    func makeLeadingAction() -> LeadingViewBody
    func makeTrailingAction() -> TrailingViewBody


    static var kind: UserProfileItemKind { get }
    init(id: Int, timestamp: Date, data: Data)
}

extension UserProfileItem {
    static var kind: UserProfileItemKind {
        String(describing: Self.self).replacingOccurrences(of: "Item", with: "").lowercased()
    }
}

struct AnyUserProfileItem: Identifiable, Equatable {
    static func == (lhs: AnyUserProfileItem, rhs: AnyUserProfileItem) -> Bool {
        lhs.id == rhs.id && lhs.kind == rhs.kind
    }
    
    private let item: any UserProfileItem
    var id: Int
    var timestamp: Date
    let kind: UserProfileItemKind
    private let make: () -> AnyView
    private let makeLeadingAction: () -> AnyView
    private let makeTrailingAction: () -> AnyView

    init<ItemType>(_ item: ItemType) where ItemType: UserProfileItem {
        self.item = item
        self.kind = ItemType.kind
        self.id = item.id
        self.timestamp = item.timestamp
        self.make = {
            AnyView(item.make())
        }
        self.makeLeadingAction = {
            AnyView(item.makeLeadingAction())
        }
        self.makeTrailingAction = {
            AnyView(item.makeTrailingAction())
        }
    }

    var contentView: AnyView {
        make()
    }
    
    var leadingActions: AnyView {
        makeLeadingAction()
    }
    
    var trailingActions: AnyView {
        makeTrailingAction()
    }
}

