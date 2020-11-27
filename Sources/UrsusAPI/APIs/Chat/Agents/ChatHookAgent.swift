//
//  ChatHookAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Client {
    
    public func chatHookAgent(ship: Ship) -> ChatHookAgent {
        return agent(ship: ship, app: "chat-hook")
    }
    
}

public class ChatHookAgent: Agent {
    
    @discardableResult public func syncedSubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/synced", handler: handler)
    }
    
    @discardableResult public func messagePokeRequest(path: Path, envelope: Envelope, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        let action = Action.message(Message(path: path, envelope: envelope))
        return pokeRequest(json: action, handler: handler)
    }
    
}

extension ChatHookAgent {
    
    public enum SubscribeResponse: Decodable {
        
        case chatHookUpdate(ChatHookUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case chatHookUpdate = "chat-hook-update"
            
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.chatHookUpdate]:
                self = .chatHookUpdate(try container.decode(ChatHookUpdate.self, forKey: .chatHookUpdate))
            default:
                throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
            }
        }
        
    }
    
    public enum Action: Encodable {
        
        case message(Message)
        
        enum CodingKeys: String, CodingKey {
            
            case message
            
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .message(let message):
                try container.encode(message, forKey: .message)
            }
        }
        
    }
    
    public struct Message: Encodable {
        
        public var path: Path
        public var envelope: Envelope
        
    }
    
}
