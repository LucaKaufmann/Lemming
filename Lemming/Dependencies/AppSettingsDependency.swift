//
//  AppSettingsDependency.swift
//  Lemming
//
//  Created by Luca Kaufmann on 2.7.2023.
//

import ComposableArchitecture

private enum AppSettingsDependencyKey: DependencyKey {
    static let liveValue: AppSettingsService = LemmingAppSettings()
}

extension DependencyValues {
    var appSettings: AppSettingsService {
        get { self[AppSettingsDependencyKey.self] }
        set { self[AppSettingsDependencyKey.self] = newValue }
    }
}
