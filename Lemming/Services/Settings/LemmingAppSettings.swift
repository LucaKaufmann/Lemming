//
//  LemmingAppSettings.swift
//  Lemming
//
//  Created by Luca Kaufmann on 2.7.2023.
//

import Foundation

struct LemmingAppSettings: AppSettingsService {
    
    func setSetting<Value: Codable>(forKey key: String, value: Value) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            print("Saving \(encoded)")
            UserDefaults.standard.setValue(encoded, forKey: key)
        }
    }
    
    func getSetting<Value: Codable>(forKey key: String) -> Value? {
        guard let encoded = UserDefaults.standard.data(forKey: key) else {
            print("Value not found for key \(key)")
            return nil
        }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(Value.self, from: encoded) {
            print("Returning \(decoded)")
            return decoded
        } else {
            print("")
            return nil
        }
    }
    
    func setInitialSettings() {
        
        if UserDefaults.standard.data(forKey: UserDefaultsKeys.postSortingKey) == nil {
            setSetting(forKey: UserDefaultsKeys.postSortingKey, value: PostSortType.hot)
        }
        
        if UserDefaults.standard.data(forKey: UserDefaultsKeys.postOriginKey) == nil {
            setSetting(forKey: UserDefaultsKeys.postOriginKey, value: PostOriginType.all)
        }
        
        if UserDefaults.standard.data(forKey: UserDefaultsKeys.commentSortingKey) == nil {
            setSetting(forKey: UserDefaultsKeys.commentSortingKey, value: _CommentSortType.hot)
        }
        
        if UserDefaults.standard.data(forKey: UserDefaultsKeys.blurNSFWKey) == nil {
            setSetting(forKey: UserDefaultsKeys.blurNSFWKey, value: true)
        }
    }
    
}
