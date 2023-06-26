//
//  LemmyCommunityService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 25.6.2023.
//

import Foundation
import Lemmy_Swift_Client

struct LemmyCommunityService: CommunityService {
    
    func getCommunity(id: Int?, name: String?, account: LemmingAccountModel?, previewInstance: String?) async throws -> CommunityModel {
        guard let instanceUrl = URL(string: (account?.instanceLink ?? previewInstance) ?? "") else {
            throw CommunityServiceError.instanceUrlError
        }
        
        let api = LemmyAPI(baseUrl: instanceUrl.appending(path: "/api/v3"))
        let request = GetCommunityRequest(auth: account?.jwt, id: id, name: name)
        
        let response = try await api.request(request)
        let communityView = response.community_view
        return CommunityModel(banner: communityView.community.banner,
                              deleted: communityView.community.deleted,
                              description: communityView.community.description,
                              hidden: communityView.community.hidden,
                              icon: communityView.community.icon,
                              id: communityView.community.id,
                              instance_id: communityView.community.instance_id,
                              local: communityView.community.local,
                              name: communityView.community.name,
                              nsfw: communityView.community.nsfw,
                              posting_restricted_to_mods: communityView.community.posting_restricted_to_mods,
                              published: communityView.community.published,
                              removed: communityView.community.removed,
                              title: communityView.community.title,
                              updated: communityView.community.updated,
                              comments: communityView.counts.comments,
                              posts: communityView.counts.posts,
                              subscribers: communityView.counts.subscribers,
                              users_active_day: communityView.counts.users_active_day,
                              users_active_half_year: communityView.counts.users_active_half_year,
                              users_active_month: communityView.counts.users_active_month,
                              users_active_week: communityView.counts.users_active_week,
                              subscribed: communityView.subscribed == .subscribed
        )
    }
    
    func subscribeToCommunity(id: Int, follow: Bool, account: LemmingAccountModel) async throws -> CommunityModel {
        guard let instanceUrl = URL(string: account.instanceLink) else {
            throw CommunityServiceError.instanceUrlError
        }
        
        let api = LemmyAPI(baseUrl: instanceUrl.appending(path: "/api/v3"))
        let request = FollowCommunityRequest(auth: account.jwt, community_id: id, follow: follow)
        
        let response = try await api.request(request)
        let communityView = response.community_view
        return CommunityModel(banner: communityView.community.banner,
                              deleted: communityView.community.deleted,
                              description: communityView.community.description,
                              hidden: communityView.community.hidden,
                              icon: communityView.community.icon,
                              id: communityView.community.id,
                              instance_id: communityView.community.instance_id,
                              local: communityView.community.local,
                              name: communityView.community.name,
                              nsfw: communityView.community.nsfw,
                              posting_restricted_to_mods: communityView.community.posting_restricted_to_mods,
                              published: communityView.community.published,
                              removed: communityView.community.removed,
                              title: communityView.community.title,
                              updated: communityView.community.updated,
                              comments: communityView.counts.comments,
                              posts: communityView.counts.posts,
                              subscribers: communityView.counts.subscribers,
                              users_active_day: communityView.counts.users_active_day,
                              users_active_half_year: communityView.counts.users_active_half_year,
                              users_active_month: communityView.counts.users_active_month,
                              users_active_week: communityView.counts.users_active_week,
                              subscribed: communityView.subscribed == .subscribed
        )
    }
}
