//
//  InviteUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

public enum InviteUpdate: Decodable {
    
    case initial(InviteUpdateInitial)
    case create(InviteUpdateCreate)
    case delete(InviteUpdateDelete)
    case invite(InviteUpdateInvite)
    case accepted(InviteUpdateAccepted)
    case decline(InviteUpdateDecline)
    
    enum CodingKeys: String, CodingKey {
        
        case initial
        case create
        case delete
        case invite
        case accepted
        case decline
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(InviteUpdateInitial.self, forKey: .initial))
        case [.create]:
            self = .create(try container.decode(InviteUpdateCreate.self, forKey: .create))
        case [.delete]:
            self = .delete(try container.decode(InviteUpdateDelete.self, forKey: .delete))
        case [.invite]:
            self = .invite(try container.decode(InviteUpdateInvite.self, forKey: .invite))
        case [.accepted]:
            self = .accepted(try container.decode(InviteUpdateAccepted.self, forKey: .accepted))
        case [.decline]:
            self = .decline(try container.decode(InviteUpdateDecline.self, forKey: .decline))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public typealias InviteUpdateInitial = Invites

public struct InviteUpdateCreate: Decodable {
    
    public var path: Path
    
}

public struct InviteUpdateDelete: Decodable {
    
    public var path: Path
    
}

public struct InviteUpdateInvite: Decodable {
    
    public var path: Path
    public var uid: String
    public var invite: Invite
    
}

public struct InviteUpdateAccepted: Decodable {
    
    public var path: Path
    public var uid: String
    
}

public struct InviteUpdateDecline: Decodable {
    
    public var path: Path
    public var uid: String
    
}

public typealias Invites = [Path: AppInvites]

public typealias AppInvites = [Path: Invite]

public struct Invite: Decodable {
    
    public var ship: Ship
    public var app: App
    public var path: Path
    public var recipient: Ship
    public var text: String
    
}
