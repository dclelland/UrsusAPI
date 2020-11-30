//
//  GroupStoreAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusHTTP

extension Client {
    
    public func groupStoreAgent(ship: Ship, state: GroupStoreAgent.State = .init()) -> GroupStoreAgent {
        return agent(ship: ship, app: "group-store", state: state)
    }
    
}

public class GroupStoreAgent: Agent<GroupStoreAgent.State, GroupStoreAgent.Request> {
    
    public struct State: AgentState {
        
        public var groups: Groups
        
        public init(groups: Groups = .init()) {
            self.groups = groups
        }
        
    }
    
    public enum Request: AgentRequest { }
    
    @discardableResult public func groupsSubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/groups", handler: handler)
    }
    
}

extension GroupStoreAgent {
    
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
                throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
            }
        }

    }

}
