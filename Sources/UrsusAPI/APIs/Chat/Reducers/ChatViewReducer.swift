//
//  ChatViewReducer.swift
//  UrsusAPI
//
//  Created by Daniel Clelland on 27/11/20.
//

import Foundation
import UrsusHTTP

public protocol ChatViewState {
    
    var inbox: Inbox { get set }
    var pendingMessages: [Path: [Envelope]] { get set }
    
}

public func reduce(_ state: inout ChatViewState, response: ChatViewAgent.SubscribeResponse) throws {
    
}
