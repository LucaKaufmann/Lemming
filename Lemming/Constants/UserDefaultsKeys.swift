//
//  UserDefaultsKeys.swift
//  Lemming
//
//  Created by Luca Kaufmann on 18.6.2023.
//

import Foundation

enum UserDefaultsKeys {
    static var accountKey = "com.codable.Lemming.currentAccount"
    static var credentialsSuiteKey = "com.codable.Lemming.credentials"
    
    static var postSortingKey = "com.codable.Lemming.postSorting"
    static var postOriginKey = "com.codable.Lemming.postOrigin"
    static var commentSortingKey = "com.codable.Lemming.commentSorting"
    static var blurNSFWKey = "com.codable.Lemming.blurNSFW"
}
