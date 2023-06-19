//
//  LemmingAccountModel.swift
//  Lemming
//
//  Created by Luca Kaufmann on 18.6.2023.
//

import Foundation

struct LemmingAccountModel: Codable, Identifiable, Equatable, Hashable {
    
    var id: String
    
    let instanceLink: String
    let username: String
    let jwt: String
    
    init(instanceLink: String, username: String, jwt: String) {
        self.id = "\(username)@\(instanceLink.replacingOccurrences(of: "https://", with: ""))"
        self.instanceLink = instanceLink
        self.username = username
        self.jwt = jwt
    }
    
    static var mockAccunts: [LemmingAccountModel] {
        return [
            .init(instanceLink: "lemmy.ml", username: "Codable", jwt: "1234"),
            .init(instanceLink: "sh.itjust.works", username: "luca", jwt: "1234"),
            .init(instanceLink: "lemmy.world", username: "SomeUser", jwt: "1234")
        ]
    }
}
