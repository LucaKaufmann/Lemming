//
//  CommunityService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 25.6.2023.
//

import Foundation
import Lemmy_Swift_Client

enum CommunityServiceError: Error {
    case noTokenReturned
    case instanceUrlError
}

protocol CommunityService {
    func getCommunity(id: Int?, name: String?, account: LemmingAccountModel?, previewInstance: String?) async throws -> CommunityModel
    func subscribeToCommunity(id: Int?, follow: Bool, account: LemmingAccountModel) async throws -> CommunityModel
}


