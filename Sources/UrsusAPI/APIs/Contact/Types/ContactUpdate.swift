//
//  ContactUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

public enum ContactUpdate: Decodable {
    
    case initial(ContactUpdateInitial)
    case create(ContactUpdateCreate)
    case delete(ContactUpdateDelete)
    case add(ContactUpdateAdd)
    case remove(ContactUpdateRemove)
    case edit(ContactUpdateEdit)
    case contacts(ContactUpdateContacts)
    
    enum CodingKeys: String, CodingKey {
        
        case initial
        case create
        case delete
        case add
        case remove
        case edit
        case contacts
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(ContactUpdateInitial.self, forKey: .initial))
        case [.create]:
            self = .create(try container.decode(ContactUpdateCreate.self, forKey: .create))
        case [.delete]:
            self = .delete(try container.decode(ContactUpdateDelete.self, forKey: .delete))
        case [.add]:
            self = .add(try container.decode(ContactUpdateAdd.self, forKey: .add))
        case [.remove]:
            self = .remove(try container.decode(ContactUpdateRemove.self, forKey: .remove))
        case [.edit]:
            self = .edit(try container.decode(ContactUpdateEdit.self, forKey: .edit))
        case [.contacts]:
            self = .contacts(try container.decode(ContactUpdateContacts.self, forKey: .contacts))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

#warning("TODO: Fix this type; should be Rolodex")

public typealias ContactUpdateInitial = [Path: [String: Contact]]

public typealias ContactUpdateCreate = Path

public typealias ContactUpdateDelete = Path

public struct ContactUpdateAdd: Decodable {
    
    public var path: Path
    public var ship: Ship
    public var contact: Contact
    
}

public struct ContactUpdateRemove: Decodable {
    
    public var path: Path
    public var ship: Ship
    
}

public struct ContactUpdateEdit: Decodable {
    
    public var path: Path
    public var ship: Ship
    public var editField: ContactEdit
    
    enum CodingKeys: String, CodingKey {
        
        case path
        case ship
        case editField = "edit-field"
        
    }
    
}

public struct ContactUpdateContacts: Decodable {
    
    public var path: Path
    public var contacts: Contacts
    
}

public typealias Rolodex = [Path: Contacts]

public typealias Contacts = [Ship: Contact]

public struct Contact: Decodable {
    
    public var nickname: String
    public var email: String
    public var phone: String
    public var website: String
    public var notes: String
    public var color: String
    public var avatar: ContactAvatar?
    
}

public typealias ContactAvatar = String

public enum ContactEdit: Decodable {
    
    case nickname(String)
    case email(String)
    case phone(String)
    case website(String)
    case notes(String)
    case color(String)
    case avatar(ContactAvatar?)
    
    enum CodingKeys: String, CodingKey {
        
        case nickname
        case email
        case phone
        case website
        case notes
        case color
        case avatar
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.nickname]:
            self = .nickname(try container.decode(String.self, forKey: .nickname))
        case [.email]:
            self = .email(try container.decode(String.self, forKey: .email))
        case [.phone]:
            self = .phone(try container.decode(String.self, forKey: .phone))
        case [.website]:
            self = .website(try container.decode(String.self, forKey: .website))
        case [.notes]:
            self = .notes(try container.decode(String.self, forKey: .notes))
        case [.color]:
            self = .color(try container.decode(String.self, forKey: .color))
        case [.avatar]:
            self = .avatar(try container.decode(ContactAvatar?.self, forKey: .avatar))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}
