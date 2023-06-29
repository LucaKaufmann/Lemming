//
//  UserService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 28.6.2023.
//

import Foundation

enum UserServiceError: Error {
    case instanceUrlError
}

protocol UserService {
    func getUserDetails(userId: Int?, username: String?, page: Int, account: LemmingAccountModel?, previewInstance: URL?) async throws -> UserProfileModel
}
