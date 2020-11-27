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

public func reduce(_ state: inout InviteStoreState, response: InviteStoreAgent.SubscribeResponse) throws {
    
}
