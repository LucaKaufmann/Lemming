//
//  SettingsRootFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 30.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct SettingsRootFeatureView: View {
    
    let store: StoreOf<SettingsRootFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                Form {
                    Section("") {
                        
                        Button("\(Image(systemName: "square.grid.2x2")) App Icons") {
                            viewStore.send(.tappedAppIcon)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.LemmingColors.onBackground)
                        Button("\(Image(systemName: "gear")) General") {
                            viewStore.send(.tappedGeneral)
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color.LemmingColors.onBackground)
                    }
                }
                .scrollContentBackground(.hidden)
                .background {
                    Color.LemmingColors.background.ignoresSafeArea()
                }
                .navigationTitle("Settings")
                .navigationDestination(store: store.scope(state: \.$appIcon, action: SettingsRootFeature.Action.appIcon)) { store in
                    AppIconFeatureView(store: store)
                }
                .navigationDestination(store: store.scope(state: \.$generalSettings, action: SettingsRootFeature.Action.generalSettings)) { store in
                    GeneralSettingsFeatureView(store: store)
                }
            }
//            .accentColor(Color.LemmingColors.accent)
        }
    }
}

struct SettingsRootFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRootFeatureView(store: Store(initialState: .init(), reducer: SettingsRootFeature()))
    }
}
