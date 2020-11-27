//
//  MetadataUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusHTTP

public enum MetadataUpdate: Decodable {
    
    case initial(MetadataUpdateInitial)
    case add(MetadataUpdateAdd)
    case update(MetadataUpdateUpdate)
    case remove(MetadataUpdateRemove)
    
    enum CodingKeys: String, CodingKey {
        
        case initial = "associations"
        case add
        case update = "update-metadata"
        case remove
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(MetadataUpdateInitial.self, forKey: .initial))
        case [.add]:
            self = .add(try container.decode(MetadataUpdateAdd.self, forKey: .add))
        case [.update]:
            self = .update(try container.decode(MetadataUpdateUpdate.self, forKey: .update))
        case [.remove]:
            self = .remove(try container.decode(MetadataUpdateRemove.self, forKey: .remove))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public typealias MetadataUpdateInitial = AppAssociations

public typealias MetadataUpdateAdd = Association

public typealias MetadataUpdateUpdate = Association

public struct MetadataUpdateRemove: Decodable {
    
    public var groupPath: Path
    public var appPath: Path
    public var appName: App
    
    enum CodingKeys: String, CodingKey {
        
        case groupPath = "group-path"
        case appPath = "app-path"
        case appName = "app-name"
        
    }
    
}

public typealias Associations = [App: AppAssociations]

public typealias AppAssociations = [Path: Association]

public struct Association: Decodable {

    public var groupPath: Path
    public var appPath: Path
    public var appName: App
    public var metadata: Metadata
    
    enum CodingKeys: String, CodingKey {
        
        case groupPath = "group-path"
        case appPath = "app-path"
        case appName = "app-name"
        case metadata
        
    }

}

public struct Metadata: Decodable {

    public var title: String
    public var description: String
    public var color: String
    public var dateCreated: String
    public var creator: Ship
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case description
        case color
        case dateCreated = "date-created"
        case creator
        
    }

}
