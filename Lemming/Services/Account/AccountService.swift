//
//  AccountService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 18.6.2023.
//

import Foundation
import KeychainSwift

enum AccountServiceError: Error {
    case noTokenReturned
}

protocol AccountService {
    func getAccounts() -> [LemmingAccountModel]
    func loginWith(username: String, password: String, instance: URL) async throws -> LemmingAccountModel
    func getCurrentAccount() -> LemmingAccountModel?
    func setCurrentAccount(_ account: LemmingAccountModel)
    func saveAccount(_ account: LemmingAccountModel) throws
}

extension AccountService {
    
    #if !os(iOS)
    func getAccounts() -> [LemmingAccountModel] {
        let userDefaults = UserDefaults(suiteName: UserDefaultsKeys.credentialsSuiteKey)
        let decoder = JSONDecoder()

        let storedAccounts = userDefaults?.dictionaryRepresentation()
            .compactMap { key, value in
            if let data = value as? Data {
                return try? decoder.decode(LemmingAccountModel.self, from: data)
            }
            return nil
        }
        
        return storedAccounts ?? []
    }
    
    func saveAccount(_ account: LemmingAccountModel) throws {
        let userDefaults = UserDefaults(suiteName: UserDefaultsKeys.credentialsSuiteKey)
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(account)
        userDefaults?.setValue(encoded, forKey: account.id)
    }
    #else
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
    
    func saveAccount(_ account: LemmingAccountModel) throws {
        let keychain = KeychainSwift()
        
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(account)

        keychain.set(encoded, forKey: account.id)
    }
    #endif
    
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
