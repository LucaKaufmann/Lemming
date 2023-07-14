//
//  AccountFeature.swift
//  Lemming
//
//  Created by Luca Kaufmann on 18.6.2023.
//

import Foundation
import ComposableArchitecture

struct AccountFeature: ReducerProtocol {
    
    @Dependency(\.accountService) var accountService
    
    struct State: Equatable {
        @BindingState var currentAccount: LemmingAccountModel?
        
        @PresentationState var addAccountSheet: AddAccountFeature.State?
        
        var availableAccounts: [LemmingAccountModel]
        var userProfile: UserProfileFeature.State
    }
    
    enum Action: Equatable, BindableAction {        
        case login(username: String, password: String)
        
        case updateAvailableAccounts([LemmingAccountModel])
        case addAccountTapped
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case addAccountSheet(PresentationAction<AddAccountFeature.Action>)

        // child features
        case userProfile(UserProfileFeature.Action)
        
        enum Delegate: Equatable {
            case updateCurrentAccount(LemmingAccountModel?)
        }
    }
    
    var body: some ReducerProtocolOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .updateAvailableAccounts(let accounts):
                    state.availableAccounts = accounts
                    return .none
                case .addAccountTapped:
                    state.addAccountSheet = .init(currentAccount: state.currentAccount)
                    return .none
                case .binding(\.$currentAccount):
                    let account = state.currentAccount
                    if let accountId = account?.id as? String {
                        state.userProfile.username = accountId
                    }
                    if let account {
                        accountService.setCurrentAccount(account)
                    }
                    return .run { send in
                        await send(.delegate(.updateCurrentAccount(account)))
                        await send(.userProfile(.refreshProfile))
                    }
                case .addAccountSheet(let action):
                    switch action {
                        case .presented(.loginSuccessful(let account)):
                            state.currentAccount = account
                            accountService.setCurrentAccount(account)
                            state.addAccountSheet = nil
                            let newAccounts = state.availableAccounts + [account]
                            return .run { send in
                                await send(.delegate(.updateCurrentAccount(account)))
                                await send(.updateAvailableAccounts(newAccounts))
                            }
                        default:
                            return .none
                    }
                case .delegate(_):
                    return .none
                default:
                    return .none
            }
        }.ifLet(\.$addAccountSheet, action: /Action.addAccountSheet) {
            AddAccountFeature()
        }
        Scope(state: \.userProfile, action: /Action.userProfile) {
            UserProfileFeature()._printChanges()
        }
    }
}

