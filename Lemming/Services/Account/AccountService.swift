//
//  AccountService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 18.6.2023.
//

import Foundation
import KeychainSwift

protocol AccountService {
    func getAccounts() -> [LemmingAccountModel]
    func loginWith(username: String, password: String, instance: URL) async throws -> LemmingAccountModel
    func getCurrentAccount() -> LemmingAccountModel?
    func setCurrentAccount(_ account: LemmingAccountModel)
}

extension AccountService {
    
    func getAccounts() -> [LemmingAccountModel] {
        let keychain = KeychainSwift()

        let decoder = JSONDecoder()
        return keychain
            .allKeys
            .compactMap { key in
                if let data = keychain.getData(key) {
                    return try? decoder.decode(LemmingAccountModel.self, from: data)
                }
                return nil
            }
    }
    
    func getCurrentAccount() -> LemmingAccountModel? {
        let accounts = getAccounts()
        
        if let accountId = UserDefaults.standard.string(forKey: UserDefaultsKeys.accountKey) {
            return accounts.first(where: { $0.id == accountId })
        }
        
        return nil
    }
    
    func setCurrentAccount(_ account: LemmingAccountModel) {
        UserDefaults.standard.set(account.id, forKey: UserDefaultsKeys.accountKey)
    }
}
