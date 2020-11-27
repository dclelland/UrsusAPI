//
//  MetadataStoreAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusHTTP

extension Client {
    
    public func metadataStoreAgent(ship: Ship) -> MetadataStoreAgent {
        return agent(ship: ship, app: "metadata-store")
    }
    
}

public class MetadataStoreAgent: Agent {
    
    @discardableResult public func allSubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/all", handler: handler)
    }
    
    @discardableResult public func appNameSubscribeRequest(app: String, handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/app-name/\(app)", handler: handler)
    }
    
}

extension MetadataStoreAgent {
    
    public enum SubscribeResponse: Decodable {
        
        case metadataUpdate(MetadataUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case metadataUpdate = "metadata-update"
            
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.metadataUpdate]:
                self = .metadataUpdate(try container.decode(MetadataUpdate.self, forKey: .metadataUpdate))
            default:
                throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
            }
        }
        
    }
    
}
