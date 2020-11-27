//
//  ContactViewAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Client {
    
    public func contactViewAgent(ship: Ship) -> ContactViewAgent {
        return agent(ship: ship, app: "contact-view")
    }
    
}

public class ContactViewAgent: Agent {
    
    @discardableResult public func primarySubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
}

extension ContactViewAgent {
    
    public enum SubscribeResponse: Decodable {
        
        case contactUpdate(ContactUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case contactUpdate = "contact-update"
            
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.contactUpdate]:
                self = .contactUpdate(try container.decode(ContactUpdate.self, forKey: .contactUpdate))
            default:
                throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
            }
        }
        
    }
    
}
