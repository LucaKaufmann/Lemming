//
//  URL+URLType.swift
//  Lemming
//
//  Created by Luca Kaufmann on 19.6.2023.
//

import Foundation

extension URL {
    var isImage: Bool {
        let imageFormats = ["jpg", "png", "gif", "jpeg"]

        let pathExtention = self.pathExtension
        return imageFormats.contains(pathExtention)
    }
}
