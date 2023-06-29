//
//  UserProfileFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 28.6.2023.
//

import SwiftUI
import ComposableArchitecture
import CachedAsyncImage

struct UserProfileFeatureView: View {
    
    let store: StoreOf<UserProfileFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { proxy in
                ScrollView {
                    VStack {
//                        Spacer()
//                            .frame(height: proxy.safeAreaInsets.top)
//                            .background {
//                                Color.blue
//                            }
                        if let user = viewStore.profile?.user {
                            UserProfileHeaderView(user: user)
                        }
                        LazyVStack {
                            ForEach(viewStore.items) { item in
                                item.contentView
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal)

                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                    .ignoresSafeArea()
                }
                .navigationTitle(viewStore.profile?.user.displayName ?? (viewStore.profile?.user.name ?? ""))
                .background {
                    Color
                        .LemmingColors
                        .background
                        .ignoresSafeArea()
                }
            }
        }
    }
}

struct UserProfileHeaderView: View {
    
    let user: UserModel
    let formatter = KMBFormatter()
    
    var body: some View {
        ZStack {
            if let bannerImageUrl = URL(string: user.banner ?? "") {
                GeometryReader { geo in
                    
                    CachedAsyncImage(url: bannerImageUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Rectangle())
                                .frame(width: geo.size.width * 0.8)
                                .frame(width: geo.size.width, height: geo.size.height)
                        } else if phase.error != nil {
                            EmptyView()
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    if let avatarImageUrl = URL(string: user.avatar ?? "") {
                        CachedAsyncImage(url: avatarImageUrl) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else if phase.error != nil {
                                Color
                                    .LemmingColors
                                    .primary
                            } else {
                                ProgressView()
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width: 75, height: 75)
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Text("Created: \(user.createdDescription)")
                        .font(.footnote)
                        .padding(2)
                        .background {
                            Capsule()
                                .fill()
                                .foregroundColor(Color.LemmingColors.primary)
                                .opacity(0.8)
                        }
                    Text("Posts: \(formatter.string(for: user.post_score) ?? "") \(Image(systemName: IconConstants.score))")
                        .font(.footnote)
                        .padding(2)
                        .background {
                            Capsule()
                                .fill()
                                .foregroundColor(Color.LemmingColors.primary)
                                .opacity(0.8)
                        }
                    Text("Comments: \(formatter.string(for: user.comment_score) ?? "") \(Image(systemName: IconConstants.score))")
                        .font(.footnote)
                        .padding(2)
                        .background {
                            Capsule()
                                .fill()
                                .foregroundColor(Color.LemmingColors.primary)
                                .opacity(0.8)
                        }
                }.padding(.bottom)
            }
        }.frame(height: heightForUser(user))
    }
    
    private func heightForUser(_ user: UserModel) -> CGFloat {
        if (user.banner ?? "").isEmpty {
            if (user.avatar ?? "").isEmpty {
                return 25
            }
            return 120
        }
        
        return 150
    }
}

struct UserProfileFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileFeatureView(store: Store(initialState: UserProfileFeature.State(userId: 916074, profile: UserProfileModel.mockUser, items: []), reducer: UserProfileFeature()._printChanges()))
        UserProfileHeaderView(user: UserModel.mockUser)
            .background {
                Color.red
            }
    }
}
