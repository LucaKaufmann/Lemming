//
//  AppSettingsService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 2.7.2023.
//

import Foundation

protocol AppSettingsService {
    func setSetting<Value: Codable>(forKey key: String, value: Value)
    func getSetting<Value: Codable>(forKey key: String) -> Value?
    
    func setInitialSettings()
}
