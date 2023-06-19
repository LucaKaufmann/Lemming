//
//  LemmyAccountService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 18.6.2023.
//

import Foundation
import Lemmy_Swift_Client
import KeychainSwift

struct LemmyAccountService: AccountService {
    
    func loginWith(username: String, password: String, instance: URL) async throws -> LemmingAccountModel {
        let api = LemmyAPI(baseUrl: instance.appending(path: "/api/v3"))
        let request = LoginRequest(username_or_email: username, password: password)
                
        let response = try await api.request(request)
        let instanceString = instance.absoluteString
        let account = LemmingAccountModel(instanceLink: instanceString, username: username, jwt: response.jwt)
        let keychain = KeychainSwift()
        
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(account)

        keychain.set(encoded, forKey: account.id)

        return account
    }
}
