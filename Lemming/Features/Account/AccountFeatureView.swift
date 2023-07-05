//
//  AccountFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 18.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct AccountFeatureView: View {
    
    let store: StoreOf<AccountFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                UserProfileFeatureView(store: store.scope(state: \.userProfile, action: AccountFeature.Action.userProfile))
//                Form {
//                    if let account = viewStore.currentAccount {
//                        Section("Current") {
//                            LabeledContent("Instance:", value: account.instanceLink)
//                            LabeledContent("Username:", value: account.username)
//                        }
//                        Section {
//                            Button("Remove account") {
//                                viewStore.send(.addAccountTapped)
//                            }.buttonStyle(LemmingButton(style: .destruction))
//                        }
//                    } else {
//                        Button("Add account") {
//                            viewStore.send(.addAccountTapped)
//                        }.buttonStyle(LemmingButton(style: .primary))
//                    }
//                }
//                .scrollContentBackground(.hidden)
                .background {
                    Color.LemmingColors.background
                        .ignoresSafeArea()
                }.sheet(store: store.scope(state: \.$addAccountSheet, action: AccountFeature.Action.addAccountSheet)) { store in
                    AddAccountFeatureView(store: store)
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Picker("Accounts", selection: viewStore.binding(\.$currentAccount)) {
                            Text("Add account")
                                .tag(nil as LemmingAccountModel?)
                            ForEach(viewStore.availableAccounts) { account in
                                Text(account.id)
                                    .tag(account as LemmingAccountModel?)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AccountFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        AccountFeatureView(store: Store(initialState: .init(availableAccounts: [], userProfile: .init(items: [])), reducer: AccountFeature()))
            .previewDisplayName("Not logged in")
        AccountFeatureView(store: Store(initialState: .init(currentAccount: LemmingAccountModel.mockAccounts.first!, availableAccounts: LemmingAccountModel.mockAccounts, userProfile: .init(items: [])), reducer: AccountFeature()._printChanges()))
            .previewDisplayName("Logged in")
    }
}
