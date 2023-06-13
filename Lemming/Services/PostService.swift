//
//  PostService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 13.6.2023.
//

import Foundation

protocol PostService {
    func getPosts() async -> [PostModel] 
}
