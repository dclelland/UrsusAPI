//
//  GroupUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

public enum GroupUpdate: Decodable {
    
    case initial(GroupUpdateInitial)
    case addGroup(GroupUpdateAddGroup)
    case addMembers(GroupUpdateAddMembers)
    case removeMembers(GroupUpdateRemoveMembers)
    case addTag(GroupUpdateAddTag)
    case removeTag(GroupUpdateRemoveTag)
    case changePolicy(GroupUpdateChangePolicy)
    case removeGroup(GroupUpdateRemoveGroup)
    case expose(GroupUpdateExpose)
    case initialGroup(GroupUpdateInitialGroup)
    
    enum CodingKeys: String, CodingKey {
        
        case initial
        case addGroup
        case addMembers
        case removeMembers
        case addTag
        case removeTag
        case changePolicy
        case removeGroup
        case expose
        case initialGroup
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(GroupUpdateInitial.self, forKey: .initial))
        case [.addGroup]:
            self = .addGroup(try container.decode(GroupUpdateAddGroup.self, forKey: .addGroup))
        case [.addMembers]:
            self = .addMembers(try container.decode(GroupUpdateAddMembers.self, forKey: .addMembers))
        case [.removeMembers]:
            self = .removeMembers(try container.decode(GroupUpdateRemoveMembers.self, forKey: .removeMembers))
        case [.addTag]:
            self = .addTag(try container.decode(GroupUpdateAddTag.self, forKey: .addTag))
        case [.removeTag]:
            self = .removeTag(try container.decode(GroupUpdateRemoveTag.self, forKey: .removeTag))
        case [.changePolicy]:
            self = .changePolicy(try container.decode(GroupUpdateChangePolicy.self, forKey: .changePolicy))
        case [.removeGroup]:
            self = .removeGroup(try container.decode(GroupUpdateRemoveGroup.self, forKey: .removeGroup))
        case [.expose]:
            self = .expose(try container.decode(GroupUpdateExpose.self, forKey: .expose))
        case [.initialGroup]:
            self = .initialGroup(try container.decode(GroupUpdateInitialGroup.self, forKey: .initialGroup))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public typealias GroupUpdateInitial = Groups

public struct GroupUpdateAddGroup: Decodable {
    
    public var resource: Resource
    public var policy: GroupPolicy
    public var hidden: Bool
    
}

public struct GroupUpdateAddMembers: Decodable {
    
    public var resource: Resource
    public var ships: [Ship]
    
}

public struct GroupUpdateRemoveMembers: Decodable {
    
    public var resource: Resource
    public var ships: [Ship]
    
}

public struct GroupUpdateAddTag: Decodable {
    
    public var tag: Tag
    public var resource: Resource
    public var ships: [Ship]
    
}

public struct GroupUpdateRemoveTag: Decodable {
    
    public var tag: Tag
    public var resource: Resource
    public var ships: [Ship]
    
}

public struct GroupUpdateChangePolicy: Decodable {
    
    public var resource: Resource
    public var diff: GroupPolicyDiff
    
}

public struct GroupUpdateRemoveGroup: Decodable {
    
    public var resource: Resource
    
}

public struct GroupUpdateExpose: Decodable {
    
    public var resource: Resource
    
}

public struct GroupUpdateInitialGroup: Decodable {
    
    public var resource: Resource
    public var group: Group
    
}

public typealias Groups = [Path: Group]

public struct Group: Decodable {
    
    public var hidden: Bool
    public var tags: Tags
    public var members: Set<Ship>
    public var policy: GroupPolicy
    
}

#warning("TODO: Fix this type; swap [String: TaggedShips] for [Tag: TaggedShips]; it also looks like TaggedShips can be an array *or* dictionary")

public typealias Tags = [String: TaggedShips]

public typealias TaggedShips = Data

public enum Tag: Decodable {
    
    case app(AppTag)
    case role(RoleTag)
    
    public init(from decoder: Decoder) throws {
        switch (Result { try AppTag(from: decoder) }, Result { try RoleTag(from: decoder) }) {
        case (.success(let appTag), .failure):
            self = .app(appTag)
        case (.failure, .success(let roleTag)):
            self = .role(roleTag)
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public struct AppTag: Decodable {
    
    public var app: App
    public var tag: String
    
}

public enum RoleTag: String, Decodable {
    
    case admin
    case moderator
    case janitor
    
}

public enum GroupPolicy: Decodable {
    
    case open(OpenPolicy)
    case invite(InvitePolicy)
    
    enum CodingKeys: String, CodingKey {
        
        case open
        case invite
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.open]:
            self = .open(try container.decode(OpenPolicy.self, forKey: .open))
        case [.invite]:
            self = .invite(try container.decode(InvitePolicy.self, forKey: .invite))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public struct InvitePolicy: Decodable {
    
    public var pending: Set<Ship>
    
}

public struct OpenPolicy: Decodable {
    
    public var banned: Set<Ship>
    public var banRanks: Set<Ship.Title>
    
}

public enum GroupPolicyDiff: Decodable {
    
    case open(OpenPolicyDiff)
    case invite(InvitePolicyDiff)
    case replace(ReplacePolicyDiff)
    
    enum CodingKeys: String, CodingKey {
        
        case open
        case invite
        case replace
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.open]:
            self = .open(try container.decode(OpenPolicyDiff.self, forKey: .open))
        case [.invite]:
            self = .invite(try container.decode(InvitePolicyDiff.self, forKey: .invite))
        case [.replace]:
            self = .replace(try container.decode(ReplacePolicyDiff.self, forKey: .replace))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public enum OpenPolicyDiff: Decodable {
    
    case allowRanks(AllowRanksDiff)
    case banRanks(BanRanksDiff)
    case allowShips(AllowShipsDiff)
    case banShips(BanShipsDiff)
    
    enum CodingKeys: String, CodingKey {
        
        case allowRanks
        case banRanks
        case allowShips
        case banShips
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.allowRanks]:
            self = .allowRanks(try container.decode(AllowRanksDiff.self, forKey: .allowRanks))
        case [.banRanks]:
            self = .banRanks(try container.decode(BanRanksDiff.self, forKey: .banRanks))
        case [.allowShips]:
            self = .allowShips(try container.decode(AllowShipsDiff.self, forKey: .allowShips))
        case [.banShips]:
            self = .banShips(try container.decode(BanShipsDiff.self, forKey: .banShips))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public typealias AllowRanksDiff = [Ship.Title]

public typealias BanRanksDiff = [Ship.Title]

public typealias AllowShipsDiff = [Ship]

public typealias BanShipsDiff = [Ship]

public enum InvitePolicyDiff: Decodable {
    
    case addInvites(AddInvitesDiff)
    case removeInvites(RemoveInvitesDiff)
    
    enum CodingKeys: String, CodingKey {
        
        case addInvites
        case removeInvites
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.addInvites]:
            self = .addInvites(try container.decode(AddInvitesDiff.self, forKey: .addInvites))
        case [.removeInvites]:
            self = .removeInvites(try container.decode(RemoveInvitesDiff.self, forKey: .removeInvites))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public typealias AddInvitesDiff = [Ship]

public typealias RemoveInvitesDiff = [Ship]

public typealias ReplacePolicyDiff = GroupPolicy
