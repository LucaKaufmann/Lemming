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
                Form {
                    if let account = viewStore.currentAccount {
                        Section("Current") {
                            LabeledContent("Instance:", value: account.instanceLink)
                            LabeledContent("Username:", value: account.username)
                        }
                        Section {
                            Button("Remove account") {
                                viewStore.send(.addAccountTapped)
                            }.buttonStyle(LemmingButton(style: .destruction))
                        }
                    } else {
                        Button("Add account") {
                            viewStore.send(.addAccountTapped)
                        }.buttonStyle(LemmingButton(style: .primary))
                    }
                }
                .scrollContentBackground(.hidden)
                .background {
                    Color.LemmingColors.background
                }.sheet(store: store.scope(state: \.$addAccountSheet, action: AccountFeature.Action.addAccountSheet)) { store in
                    AddAccountFeatureView(store: store)
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Picker("Accounts", selection: viewStore.binding(\.$currentAccount)) {
                            Text("Select account")
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
        AccountFeatureView(store: Store(initialState: .init(availableAccounts: []), reducer: AccountFeature()))
            .previewDisplayName("Not logged in")
        AccountFeatureView(store: Store(initialState: .init(currentAccount: LemmingAccountModel.mockAccunts.first!, availableAccounts: LemmingAccountModel.mockAccunts), reducer: AccountFeature()._printChanges()))
            .previewDisplayName("Logged in")
    }
}
