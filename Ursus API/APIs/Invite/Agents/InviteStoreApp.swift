//
//  InviteStoreApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Client {
    
    public func inviteStore(ship: Ship) -> InviteStoreApp {
        return app(ship: ship, app: "invite-store")
    }
    
}

public class InviteStoreApp: AirlockApp {
    
    @discardableResult public func allSubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
}

extension InviteStoreApp {
    
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
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }
        
    }
    
}
