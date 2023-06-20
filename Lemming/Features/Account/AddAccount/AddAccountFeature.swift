//
//  AddAccountFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 19.6.2023.
//

import Foundation
import ComposableArchitecture

struct AddAccountFeature: ReducerProtocol {
    
    @Dependency(\.accountService) var accountService
    @Dependency(\.dismiss) var dismiss
    
    struct State: Equatable {
        var currentAccount: LemmingAccountModel?
        var viewState: ViewState
        
        @BindingState var instance: String
        @BindingState var username: String
        @BindingState var password: String
      
        init(currentAccount: LemmingAccountModel?) {
            self.currentAccount = currentAccount
            self.instance = currentAccount?.instanceLink ?? ""
            self.username = currentAccount?.username ?? ""
            self.password = ""
            self.viewState = .none
        }
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        
        case loginTapped
        case dismissTapped
        
        case loginSuccessful(LemmingAccountModel)
        case loginFailed(AddAccountError)
    }
    
    enum AddAccountError: Error {
        case instanceUrlError
        case loginFailedError
    }
    
    enum ViewState: Equatable {
        case none
        case isLoading
        case loginSuccessful
        case loginFailed
    }
    
    var body: some ReducerProtocolOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .loginTapped:
                    let username = state.username
                    let password = state.password
                    let instance = state.instance.replacingOccurrences(of: "https://", with: "")
                    
                    let formattedInstanceUrl = "https://\(instance)"
                    
                    if let url = URL(string: formattedInstanceUrl) {
                        state.viewState = .isLoading
                        return .task {
                            
                            do {
                                let account = try await accountService.loginWith(username: username, password: password, instance: url)
                                return .loginSuccessful(account)
                            } catch {
                                print("\(error)")
                                return .loginFailed(.loginFailedError)
                            }
                        }
                    } else {
                        return .send(.loginFailed(.instanceUrlError))
                    }
                case .dismissTapped:
                    return .fireAndForget {
                        await self.dismiss()
                    }
                case .loginSuccessful(_):
                    state.viewState = .loginSuccessful
                    return .none
                case .loginFailed(let error):
                    state.viewState = .loginFailed
                    return .none
                case .binding(_):
                    return .none
            }
        }
    }
}
