//
//  CommunityModel.swift
//  Lemming
//
//  Created by Luca Kaufmann on 25.6.2023.
//

import Foundation

struct CommunityModel: Equatable, Identifiable, Hashable {
    let banner: String?
    let deleted: Bool
    let description: String?
    let hidden: Bool
    let icon: String?
    let id: Int
    let instance_id: Int
    let local: Bool
    let name: String
    let nsfw: Bool
    let posting_restricted_to_mods: Bool
    let published: String
    let removed: Bool
    let title: String
    let updated: String?
    
    // Aggregates
    let comments: Int
    let posts: Int
    let subscribers: Int
    let users_active_day: Int
    let users_active_half_year: Int
    let users_active_month: Int
    let users_active_week: Int
    
    static var mockModels: [CommunityModel] {
        return [
            .init(banner: nil, deleted: false, description: "Mock community", hidden: false, icon: nil, id: 1, instance_id: 1, local: false, name: "Mock community 1", nsfw: false, posting_restricted_to_mods: false, published: "", removed: false, title: "Mock community title", updated: nil, comments: 100, posts: 100, subscribers: 100, users_active_day: 1, users_active_half_year: 5, users_active_month: 10, users_active_week: 10)
        ]
    }
}
