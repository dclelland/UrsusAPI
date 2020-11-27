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
    var loadingMessages: [Path: Bool] { get set }
    
}

public func reduce(_ state: inout ChatViewState, _ response: ChatViewAgent.SubscribeResponse) throws {
    switch response {
    case .chatUpdate(let update):
        switch update {
        case .initial(let initial):
            state.inbox = initial
        case .create(let create):
            state.inbox[create.path] = Mailbox(
                config: MailboxConfig(
                    length: 0,
                    read: 0
                ),
                envelopes: []
            )
        case .delete(let delete):
            state.inbox[delete.path] = nil
        case .message(let message):
            if let mailbox = state.inbox[message.path] {
                state.inbox[message.path]?.envelopes = [message.envelope] + mailbox.envelopes
                state.inbox[message.path]?.config.length = mailbox.config.length + 1
            }
            state.pendingMessages[message.path]?.removeAll { envelope in
                envelope.uid == message.envelope.uid
            }
        case .messages(let messages):
            if let mailbox = state.inbox[messages.path] {
                state.inbox[messages.path]?.envelopes = mailbox.envelopes + messages.envelopes
            }
            state.loadingMessages[messages.path] = nil
        case .read(let read):
            if let mailbox = state.inbox[read.path] {
                state.inbox[read.path]?.config.read = mailbox.config.length
            }
        }
    }
}
