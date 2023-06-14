//
//  RelativeDateFormatterDependency.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import ComposableArchitecture
import Foundation

private enum RelativeDateTimeFormatterKey: DependencyKey {
    static let liveValue: DateFormatterService = DateFormatterService()
}

extension DependencyValues {
    var dateFormatterService: DateFormatterService {
        get { self[RelativeDateTimeFormatterKey.self] }
        set { self[RelativeDateTimeFormatterKey.self] = newValue }
    }
}
