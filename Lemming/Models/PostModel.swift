//
//  PostModel.swift
//  Lemming
//
//  Created by Luca Kaufmann on 12.6.2023.
//

import Foundation

struct PostModel: Equatable, Identifiable, Hashable {
    let id: Int
    
    let title: String
    let body: String?
    let embed_description: String?
    let embed_title: String?
    let embed_video_url: URL?
    let thumbnail_url: URL?
    let url: URL?
    let community: String
    let numberOfUpvotes: Int
    let numberOfComments: Int
    let my_vote: Int?
    let timestamp: Date?
    let timestampDescription: String
    let user: String
    
    static var mockPosts: [PostModel] {
        let post1 = PostModel(id: 1,
                              title: "[Megathread] Reddit going dark",
                              body: "Good luck, have fun",
                              embed_description: nil,
                              embed_title: nil,
                              embed_video_url: nil,
                              thumbnail_url: nil,
                              url: nil,
                              community: "lemmy",
                              numberOfUpvotes: 420420,
                              numberOfComments: 1337,
                              my_vote: 1,
                              timestamp: Date(),
                              timestampDescription: "1min ago",
                              user: "Admin")
        let post2 = PostModel(id: 2,
                              title: "Another mock post",
                              body: """
                              Title: Discover the Power of Lemmy: The Ultimate Community-Driven Platform

                              Introduction:
                              In the ever-expanding realm of online communities, finding a platform that genuinely values user autonomy, privacy, and open-source principles can be a challenging task. Enter Lemmy, the rising star among community-driven platforms that is taking the internet by storm. With its commitment to user control, content moderation, and transparency, Lemmy stands out as a shining beacon in the era of social media giants. Join us on a journey to explore the power and potential of Lemmy, where your voice truly matters.

                              Section 1: Embrace the Power of Community
                              Lemmy is built on the foundation of community empowerment. It embraces the idea that the platform belongs to its users and strives to create an inclusive space where individuals can connect, share, and collaborate freely. With Lemmy, you are not just a passive consumer; you become an active participant in shaping the community’s direction. From voting on content to contributing your thoughts, ideas, and even code, Lemmy gives you the tools to make your voice heard.

                              Section 2: Privacy and Transparency at the Core
                              Privacy is paramount in the digital age, and Lemmy takes it seriously. Unlike traditional social media platforms, Lemmy doesn’t track your every move or sell your data to advertisers. With robust privacy features, Lemmy ensures that you can interact with others without worrying about invasive data collection. Moreover, as an open-source platform, Lemmy’s code is accessible to everyone, fostering transparency and empowering users to verify the integrity of the platform.

                              Section 3: Content Moderation: By the Community, For the Community
                              One of the biggest challenges faced by online communities is content moderation. Lemmy tackles this issue with a unique approach. Instead of relying on a centralized authority, Lemmy allows each community to set its own moderation policies and elect its own moderators. This decentralized approach empowers communities to maintain their standards while avoiding the pitfalls of one-size-fits-all moderation. With Lemmy, you can be part of a community that reflects your values.

                              Section 4: Customization and Extensibility
                              Lemmy believes in giving users the freedom to make the platform their own. Whether it’s creating custom themes, extending functionality with plugins, or even self-hosting your own instance, Lemmy provides the tools to tailor the experience to your preferences. This flexibility empowers users and communities to curate their environment, fostering unique and engaging spaces.

                              Conclusion:
                              In a world dominated by algorithmic feeds, targeted advertisements, and privacy concerns, Lemmy stands as a breath of fresh air. With its emphasis on community, privacy, transparency, and customization, Lemmy offers a compelling alternative for those seeking a more meaningful online experience. Join the Lemmy revolution today and be part of a growing movement that puts the power back into the hands of the users. Together, let’s redefine what it means to connect, share, and engage on the internet.
""",
                              embed_description: nil,
                              embed_title: nil,
                              embed_video_url: nil,
                              thumbnail_url: nil,
                              url: nil,
                              community: "swift",
                              numberOfUpvotes: 123,
                              numberOfComments: 1,
                              my_vote: 0,
                              timestamp: Date(),
                              timestampDescription: "1hr ago",
                              user: "Codable")
        let post3 = PostModel(id: 3,
                              title: "How are they so cute?",
                              body: nil,
                              embed_description: nil,
                              embed_title: nil,
                              embed_video_url: nil,
                              thumbnail_url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/ef/Tunturisopuli_Lemmus_Lemmus.jpg"),
                              url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/ef/Tunturisopuli_Lemmus_Lemmus.jpg"),
                              community: "lemmings",
                              numberOfUpvotes: 1,
                              numberOfComments: 0,
                              my_vote: -1,
                              timestamp: Date(),
                              timestampDescription: "1d ago",
                              user: "LemmingFan123")
        
        return [post1, post2, post3]
    }
}
