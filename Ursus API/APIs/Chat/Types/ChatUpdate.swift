//
//  ChatUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

public enum ChatUpdate: Decodable {
    
    case initial(ChatUpdateInitial)
    case create(ChatUpdateCreate)
    case delete(ChatUpdateDelete)
    case message(ChatUpdateMessage)
    case messages(ChatUpdateMessages)
    case read(ChatUpdateRead)
    
    enum CodingKeys: String, CodingKey {
        
        case initial
        case create
        case delete
        case message
        case messages
        case read
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(ChatUpdateInitial.self, forKey: .initial))
        case [.create]:
            self = .create(try container.decode(ChatUpdateCreate.self, forKey: .create))
        case [.delete]:
            self = .delete(try container.decode(ChatUpdateDelete.self, forKey: .delete))
        case [.message]:
            self = .message(try container.decode(ChatUpdateMessage.self, forKey: .message))
        case [.messages]:
            self = .messages(try container.decode(ChatUpdateMessages.self, forKey: .messages))
        case [.read]:
            self = .read(try container.decode(ChatUpdateRead.self, forKey: .read))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

public enum ChatAction: String, Decodable {
    
    case create
    case delete
    case message
    case read
    
}

public typealias ChatUpdateInitial = Inbox

public struct ChatUpdateCreate: Decodable {
    
    public var path: Path
    
}

public struct ChatUpdateDelete: Decodable {
    
    public var path: Path
    
}

public struct ChatUpdateMessage: Decodable {
    
    public var path: Path
    public var envelope: Envelope
    
}

public struct ChatUpdateMessages: Decodable {
    
    public var path: Path
    public var envelopes: [Envelope]
    public var start: Int
    public var end: Int
    
}

public struct ChatUpdateRead: Decodable {
    
    public var path: Path
    
}

public typealias Inbox = [Path: Mailbox]

public struct Mailbox: Decodable {
    
    public var config: MailboxConfig
    public var envelopes: [Envelope]
    
}

public struct MailboxConfig: Decodable {
    
    public var length: Int
    public var read: Int
    
}

public struct Envelope: Codable {

    public var uid: String
    public var number: Int
    public var author: Ship
    public var when: Date
    public var letter: Letter
    
}

public enum Letter: Codable {
    
    case text(LetterText)
    case url(LetterURL)
    case code(LetterCode)
    case me(LetterMe)
    
    enum CodingKeys: String, CodingKey {
        
        case text
        case url
        case code
        case me
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.text]:
            self = .text(try container.decode(LetterText.self, forKey: .text))
        case [.url]:
            self = .url(try container.decode(LetterURL.self, forKey: .url))
        case [.code]:
            self = .code(try container.decode(LetterCode.self, forKey: .code))
        case [.me]:
            self = .me(try container.decode(LetterMe.self, forKey: .me))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode(text, forKey: .text)
        case .url(let url):
            try container.encode(url, forKey: .url)
        case .code(let code):
            try container.encode(code, forKey: .code)
        case .me(let me):
            try container.encode(me, forKey: .me)
        }
    }
    
}

public typealias LetterText = String

public typealias LetterURL = String

public struct LetterCode: Codable {
    
    public var expression: String
    public var output: [[String]]
    
}

public typealias LetterMe = String
