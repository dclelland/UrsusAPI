//
//  InviteStoreAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Client {
    
    public func inviteStoreAgent(ship: Ship) -> InviteStoreAgent {
        return agent(ship: ship, app: "invite-store")
    }
    
}

public class InviteStoreAgent: Agent {
    
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
