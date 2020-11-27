//
//  ChatHookReducer.swift
//  UrsusAPI
//
//  Created by Daniel Clelland on 27/11/20.
//

import Foundation

public protocol ChatHookState {
    
    var synced: Synced { get set }
    
}

public func reduce(_ state: inout ChatHookState, _ response: ChatHookAgent.SubscribeResponse) throws {
    switch response {
    case .chatHookUpdate(let update):
        state.synced = update
    }
}
