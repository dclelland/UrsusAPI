//
//  InviteStoreReducer.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 27/11/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

public protocol InviteStoreState {
    
    var invites: Invites { get set }
    
}

public func reduce(_ state: inout InviteStoreState, _ response: InviteStoreAgent.SubscribeResponse) throws {
    switch response {
    case .inviteUpdate(let update):
        switch update {
        case .initial(let initial):
            state.invites = initial
        case .create(let create):
            state.invites[create.path] = [:]
        case .delete(let delete):
            state.invites[delete.path] = nil
        case .invite(let invite):
            state.invites[invite.path]?[invite.uid] = invite.invite
        case .accepted(let accepted):
            state.invites[accepted.path]?[accepted.uid] = nil
        case .decline(let decline):
            state.invites[decline.path]?[decline.uid] = nil
        }
    }
}
