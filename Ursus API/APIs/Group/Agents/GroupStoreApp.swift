//
//  GroupStoreApp.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusAirlock

extension Client {
    
    public func groupStore(ship: Ship) -> GroupStoreApp {
        return app(ship: ship, app: "group-store")
    }
    
}

public class GroupStoreApp: AirlockApp {
    
    @discardableResult public func groupsSubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/groups", handler: handler)
    }
    
}

extension GroupStoreApp {
    
    public enum SubscribeResponse: Decodable {

        case groupUpdate(GroupUpdate)

        enum CodingKeys: String, CodingKey {

            case groupUpdate

        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.groupUpdate]:
                self = .groupUpdate(try container.decode(GroupUpdate.self, forKey: .groupUpdate))
            default:
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
            }
        }

    }

}
