//
//  GraphUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 20/11/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusHTTP

public enum GraphUpdate: Decodable {
    
    case keys(GraphUpdateKeys)
    case addGraph(GraphUpdateAddGraph)
    case removeGraph(GraphUpdateRemoveGraph)
    case addNodes(GraphUpdateAddNodes)
    case removeNodes(GraphUpdateRemoveNodes)
    
    enum CodingKeys: String, CodingKey {
        
        case keys
        case addGraph = "add-graph"
        case removeGraph = "remove-graph"
        case addNodes = "add-nodes"
        case removeNodes = "remove-nodes"
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.keys]:
            self = .keys(try container.decode(GraphUpdateKeys.self, forKey: .keys))
        case [.addGraph]:
            self = .addGraph(try container.decode(GraphUpdateAddGraph.self, forKey: .addGraph))
        case [.removeGraph]:
            self = .removeGraph(try container.decode(GraphUpdateRemoveGraph.self, forKey: .removeGraph))
        case [.addNodes]:
            self = .addNodes(try container.decode(GraphUpdateAddNodes.self, forKey: .addNodes))
        case [.removeNodes]:
            self = .removeNodes(try container.decode(GraphUpdateRemoveNodes.self, forKey: .removeNodes))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public typealias GraphUpdateKeys = [Resource]

public struct GraphUpdateAddGraph: Decodable {
    
    #warning("TODO: Finish GraphUpdateAddGraph; review `graph` type")
    
    public var graph: Graph
    public var resource: Resource
    public var mark: Mark
    public var overwrite: Bool
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case graph
        case resource
        case mark
        case overwrite
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var graphContainer = try container.nestedUnkeyedContainer(forKey: .graph)
        
        self.graph = []
        while graphContainer.isAtEnd == false {
            var childContainer = try graphContainer.nestedUnkeyedContainer()
            self.graph.append((try childContainer.decode(String.self), try childContainer.decode(GraphNode.self)))
        }
        
        self.resource = try container.decode(Resource.self, forKey: .resource)
        self.mark = try container.decode(Mark.self, forKey: .mark)
        self.overwrite = try container.decode(Bool.self, forKey: .overwrite)
    }
    
}

public typealias GraphUpdateRemoveGraph = Resource

public struct GraphUpdateAddNodes: Decodable {
    
    #warning("TODO: Finish GraphUpdateAddNodes; review `nodes` type; is the index a big int...?")
    
    public var nodes: [(Index, GraphNode)]
    public var resource: Resource
    
    enum CodingKeys: String, CodingKey {
        
        case nodes
        case resource
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var nodesContainer = try container.nestedUnkeyedContainer(forKey: .nodes)
        
        self.nodes = []
        while nodesContainer.isAtEnd == false {
            var nodeContainer = try nodesContainer.nestedUnkeyedContainer()
            self.nodes.append((try nodeContainer.decode(String.self), try nodeContainer.decode(GraphNode.self)))
        }
        
        self.resource = try container.decode(Resource.self, forKey: .resource)
    }
    
}

public struct GraphUpdateRemoveNodes: Decodable {
    
    #warning("TODO: Finish GraphUpdateRemoveNodes: should indices get split?")
    
    public var indices: [Index]
    public var resource: Resource
    
}


/* ---------------------------------- */

public struct TextContent: Decodable {
    
    public var text: String
    
}

public struct URLContent: Decodable {
    
    public var url: String
    
}

public struct CodeContent: Decodable {
    
    public var expression: String
    public var output: String
    
}

public struct ReferenceContent: Decodable {
    
    #warning("This type is more complex")
    public var uid: String
    
}

public struct MentionContent: Decodable {
    
    public var mention: String
    
}

public enum Content: Decodable {
    
    case text(TextContent)
    case url(URLContent)
    case code(CodeContent)
    case reference(ReferenceContent)
    case mention(MentionContent)
    
    enum CodingKeys: String, CodingKey {
        
        case text
        case url
        case expression
        case output
        case uid
        case mention
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.text]:
            self = .text(try TextContent(from: decoder))
        case [.url]:
            self = .url(try URLContent(from: decoder))
        case [.expression, .output]:
            self = .code(try CodeContent(from: decoder))
        case [.uid]:
            self = .reference(try ReferenceContent(from: decoder))
        case [.mention]:
            self = .mention(try MentionContent(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
        }
    }
    
}

public struct Post: Decodable {
    
    #warning("Review these properties; is 'pending' the correct type or even necessary?")
    
    public var author: Ship
    public var contents: [Content]
    #warning("This type is an atom")
    public var hash: String?
    public var index: Index
//    public var pending: Bool?
    #warning("This type is more complex")
    public var signatures: [String]
    public var timeSent: Date
    
    enum CodingKeys: String, CodingKey {
        
        case author
        case contents
        case hash
        case index
//        case pending
        case signatures
        case timeSent = "time-sent"
        
    }
    
}

public struct Resource: Decodable {
    
    public var ship: Ship
    public var name: String
    
    #warning("Review both these helper methods")
    
    public var description: String {
        return "\(Ship.Prefixless(ship))/\(name)"
    }
    
    public var path: Path {
        return "/ship/\(ship.description)/\(name)"
    }
    
}

public struct GraphNode: Decodable {
    
    #warning("Children might need type `Graph?`")
    
    public var children: Graph?
    public var post: Post
    
    enum CodingKeys: String, CodingKey {
        
        case children
        case post
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if try container.decodeNil(forKey: .children) == false {
            var childrenContainer = try container.nestedUnkeyedContainer(forKey: .children)
            
            self.children = []
            while childrenContainer.isAtEnd == false {
                var childContainer = try childrenContainer.nestedUnkeyedContainer()
                self.children?.append((try childContainer.decode(String.self), try childContainer.decode(GraphNode.self)))
            }
        }
        
        self.post = try container.decode(Post.self, forKey: .post)
    }
    
}

#warning("Index needs a special parser; should parse to a list of atoms")
public typealias Index = String

#warning("This might need a full-blown custom collection type, see: https://github.com/urbit/urbit/blob/master/pkg/interface/src/logic/lib/BigIntOrderedMap.ts; also see: https://github.com/lukaskubanek/OrderedDictionary; perhaps add a basic atom (`@`) type to UrsusAtom; also need to confirm an array of arrays (containing an index and a graph node) is the correct format")

public typealias Graph = [(Index, GraphNode)]

#warning("Review this ('export type Graphs = { [rid: string]: Graph };')")

public typealias Graphs = [String: Graph]
