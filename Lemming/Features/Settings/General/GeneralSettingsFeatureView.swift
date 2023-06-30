//
//  GeneralSettingsFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 30.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct GeneralSettingsFeatureView: View {
    
    let store: StoreOf<GeneralSettingsFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
                Form {
                    Section("Posts") {
                        Toggle(isOn: viewStore.binding(\.$blurNSFW), label: {
                            Text("Blur NSFW")
                        })
                        Picker("Sorting", selection: viewStore.binding(\.$postSorting)) {
                            ForEach(PostSortType.allCases, id: \.self) { sortType in
                                Text(sortType.rawValue)
                                    .tag(sortType)
                            }
                        }
                        Picker("Origin", selection: viewStore.binding(\.$postOrigin)) {
                            ForEach(PostOriginType.allCases, id: \.self) { originType in
                                Text(originType.rawValue)
                                    .tag(originType)
                            }
                        }
                    }
                    .listRowBackground(Color.LemmingColors.onBackground)

                    Section("Comments") {
                        Picker("Sorting", selection: viewStore.binding(\.$commentSorting)) {
                            ForEach(_CommentSortType.allCases, id: \.self) { sortType in
                                Text(sortType.rawValue)
                                    .tag(sortType)
                            }
                        }
                    }
                    .listRowBackground(Color.LemmingColors.onBackground)
                }
                .scrollContentBackground(.hidden)
                .background {
                    Color.LemmingColors.background.ignoresSafeArea()
                }
                .navigationTitle("General")
        }
    }
}

struct GeneralSettingsFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GeneralSettingsFeatureView(store: .init(initialState: .init(postSorting: .hot, blurNSFW: false, postOrigin: .all, commentSorting: .hot), reducer: GeneralSettingsFeature()))
        }
    }
}
