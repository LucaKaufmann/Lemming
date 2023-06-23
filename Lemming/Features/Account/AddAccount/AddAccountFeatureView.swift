//
//  AddAccountFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 19.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct AddAccountFeatureView: View {
 
    let store: StoreOf<AddAccountFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                Form {
                    Section("Instance") {
                        LabeledContent("Instance") {
                            TextField("lemmy.ml", text: viewStore.binding(\.$instance))
                                #if !os(macOS)
                                .textInputCapitalization(.none)
                                #endif
                                .disableAutocorrection(true)
                        }
                        LabeledContent("Username") {
                            TextField("Username", text: viewStore.binding(\.$username))
                                #if !os(macOS)
                                .textInputCapitalization(.none)
                                #endif
                                .disableAutocorrection(true)
                        }
                        LabeledContent("Password") {
                            SecureField("Password", text: viewStore.binding(\.$password))
                                #if !os(macOS)
                                .textInputCapitalization(.none)
                                #endif
                                .disableAutocorrection(true)
                        }
                    }
                    Button(action: {
                        if viewStore.viewState != .isLoading {
                            viewStore.send(.loginTapped)
                        }
                    }, label: {
                        switch viewStore.viewState {
                            case .isLoading:
                                ProgressView()
                            case .loginFailed:
                                Text("Try again")
                            default:
                                Text("Log in")
                        }
                    })
                    .buttonStyle(LemmingButton(style: viewStore.viewState == .loginFailed ? .destruction : .primary))
                }.toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Cancel") {
                            viewStore.send(.dismissTapped)
                        }
                    }
                }
            }
        }
    }
}

struct AddAccountFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountFeatureView(store: Store(initialState: .init(currentAccount: LemmingAccountModel.mockAccunts.first), reducer: AddAccountFeature()))
    }
}
