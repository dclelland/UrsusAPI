//
//  InviteStoreAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusHTTP

extension Client {
    
    public func inviteStoreAgent(ship: Ship, state: InviteStoreAgent.State = .init()) -> InviteStoreAgent {
        return agent(ship: ship, app: "invite-store", state: state)
    }
    
}

public class InviteStoreAgent: Agent<InviteStoreAgent.State, InviteStoreAgent.Request> {
    
    public struct State: AgentState {
        
        public var invites: Invites
        
        public init(invites: Invites = .init()) {
            self.invites = invites
        }
        
    }
    
    public enum Request: AgentRequest { }
    
    @discardableResult public func allSubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
}

extension InviteStoreAgent {
    
    public enum SubscribeResponse: Decodable {
        
        case inviteUpdate(InviteUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case inviteUpdate = "invite-update"
            
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.inviteUpdate]:
                self = .inviteUpdate(try container.decode(InviteUpdate.self, forKey: .inviteUpdate))
            default:
                throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
            }
        }
        
    }
    
}
