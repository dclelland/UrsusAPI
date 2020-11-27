//
//  ChatViewAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 16/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusHTTP

extension Client {
    
    public func chatViewAgent(ship: Ship) -> ChatViewAgent {
        return agent(ship: ship, app: "chat-view")
    }
    
}

public class ChatViewAgent: Agent {
    
    @discardableResult public func primarySubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/primary", handler: handler)
    }
    
    @discardableResult public func messagesRequest(path: Path, start: Int, end: Int, handler: @escaping (AFResult<SubscribeResponse>) -> Void) -> DataRequest {
        let url = client.credentials.url.appendingPathComponent("/chat-view/paginate/\(start)/\(end)\(path)")
        return client.session
            .request(url)
            .validate()
            .responseDecodable(of: SubscribeResponse.self, decoder: ClientJSONDecoder()) { response in
                handler(response.result)
            }
    }
    
}

extension ChatViewAgent {
    
    public enum SubscribeResponse: Decodable {
        
        case chatUpdate(ChatUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case chatUpdate = "chat-update"
            
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.chatUpdate]:
                self = .chatUpdate(try container.decode(ChatUpdate.self, forKey: .chatUpdate))
            default:
                throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
            }
        }
        
    }
    
}
