//
//  ContactViewAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusHTTP

extension Client {
    
    public func contactViewAgent(ship: Ship, state: ContactViewAgent.State = .init()) -> ContactViewAgent {
        return agent(ship: ship, app: "contact-view", state: state)
    }
    
}

public class ContactViewAgent: Agent<ContactViewAgent.State, ContactViewAgent.Request> {
    
    public struct State: AgentState {
        
        public var contacts: Rolodex
        
        public init(contacts: Rolodex = .init()) {
            self.contacts = contacts
        }
        
    }
    
    public enum Request: AgentRequest { }
    
}

extension ContactViewAgent {
    
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
