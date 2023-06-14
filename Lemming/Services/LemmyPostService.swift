//
//  LemmyPostService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 13.6.2023.
//

import Foundation
import Lemmy_Swift_Client

struct LemmyPostService: PostService {
    
    let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:MM:SS"
    }
    
    func getPosts(page: Int = 0) async -> [PostModel] {
        if let url = URL(string: "https://lemmy.ml/api/v3") {
            // Create an instance of the Lemmy API with the base URL of your Lemmy instance
            let api = LemmyAPI(baseUrl: url)

            // Create a SearchRequest object with the `q` parameter
//            let request = SearchRequest(q: "Lemmy-Swift-Client")
            let request = GetPostsRequest(page: page)
            // Send the request to the Lemmy API
            do {
                let response = try await api.request(request)
                return response.posts.map { postView in
                    let post = postView.post
                    print(post.id)
                    return PostModel(id: post.id,
                                     title: post.name,
                                     community: postView.community.name,
                                     numberOfUpvotes: postView.counts.upvotes,
                                     numberOfComments: postView.counts.comments,
                                     timestamp: dateFormatter.date(from: post.updated ?? "") ?? .now,
                                     user: postView.creator.name)
                }
            } catch {
                print("Lemmy error \(error)")
            }
        }
        return []
    }
}
