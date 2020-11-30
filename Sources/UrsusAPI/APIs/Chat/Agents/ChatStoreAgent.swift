//
//  ChatStoreAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 23/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusHTTP

extension Client {
    
    public func chatStoreAgent(ship: Ship, state: ChatStoreAgent.State = .init()) -> ChatStoreAgent {
        return agent(ship: ship, app: "chat-store", state: state)
    }
    
}

public class ChatStoreAgent: Agent<ChatStoreAgent.State, ChatStoreAgent.Request> {
    
    public struct State: AgentState {
        
        public init()
        
    }
    
    public enum Request: AgentRequest { }
    
}

extension ChatStoreAgent {
    
    @discardableResult public func readPokeRequest(path: Path, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let action = Action.read(Read(path: path))
        return pokeRequest(json: action, handler: handler)
    }
    
}

extension ChatStoreAgent {
    
    public enum Action: Encodable {
        
        case read(Read)
        
        enum CodingKeys: String, CodingKey {
            
            case read
            
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .read(let read):
                try container.encode(read, forKey: .read)
            }
        }
        
    }
    
    public struct Read: Encodable {
        
        public var path: Path
        
    }
    
}

