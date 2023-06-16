//
//  CommentService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation

protocol CommentService {
    func getComments(forPost postId: Int) async -> [CommentModel]
}
