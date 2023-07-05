# Lemming
Lemming is an iOS client for the [link aggregator platform Lemmy](https://join-lemmy.org/). The goal is to create a simple, easy to use client with focus on UI and user experience, inspired by reddit apps such as Apollo and narwhal. The app will take advantage of native Apple platform features, eventually adding support for a macOS, watchOS and visionOS app, adding widgets and shortcuts.


## Architecture
The latest version of [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) is used, including using their navigation and dependency injection tools. 

### Features
In general each feature consists of a reducer and a view, following the naming style of:
`RootFeature` + `RootFeatureView`

`PostsFeature` + `PostsFeatureView`

etc.

### Services
Dependencies are implemented as services. Services are defined as protocols to allow for implementation of mock services for testing as well as supporting other platforms in the future (for example [kbin.social](https://kbin.social/)).
Services don't hold any state, they're utilities that are used in reducers for example for fetching or formatting data. 

The following services are implemented:

| Service          | Purpose                                                         |
|------------------|-----------------------------------------------------------------|
| UserService      | Fetching user related data                                      |
| CommunityService | Fetching community data, community mutations (subscribe)        |
| PostService      | Fetching post data, post mutations (votes)                      |
| CommentService   | Fetching comment data, comment mutations (votes, replies)       |
| AccountService   | Fetching account data, handle login, store accounts in keychain |
| SettingsService  | Reading and writing app settings to UserDefaults                |


### Navigation

Navigation is generally handled by TCA, making it state driven and testable. There are different types of navigation:

- Stack based navigation: A stack of views that can be pushed and popped from, used for views that can have an infinite amount of views on the stack (example: tapping on a post, then tapping on the community of that post, then tapping on another post etc.)
- Destination based navigation: Predefined destinations, for example the settings
- Sheets: Sheets that are shown/hidden based on state

## Design

A set of colors is available and accessible under `Color.LemmingColors.colorname`. The main colors being used are the background color, `primary` color and accent color. In general, things like links, toolbar items, other interactable elements should get the orange accent color. Other information or labels get the accentGray, accentBrown and accentBeige colors.

## Roadmap & Features

The goal is to finish a set of basic features and then ship a first Testflight build. The following features should be completed before launch:

Phase 1:

- [x] Login
- [x] Load posts
- [x] Filter posts
- [x] Load user profiles
- [x] Upvote/downvote posts
- [x] Comment on posts
- [x] Load communities
- [x] Follow communities
- [ ] Create new posts
- [ ] Allow browsing posts and instances when not logged in
- [ ] User onboarding


Phase 2:
- [ ] Search feature
- [ ] Community discovery
- [ ] Block users
- [ ] Block communities
- [ ] Filter posts


In the future:
- Widgets
- Apple watch app
- macOS app

