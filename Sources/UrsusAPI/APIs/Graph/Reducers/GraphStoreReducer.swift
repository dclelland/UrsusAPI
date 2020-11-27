//
//  GraphStoreReducer.swift
//  UrsusAPI
//
//  Created by Daniel Clelland on 27/11/20.
//

import Foundation

public protocol GraphStoreState {
    
    var graphs: Graphs { get set }
    var graphKeys: Set<String> { get set }
    
}

public func reduce(_ state: inout GraphStoreState, response: GraphStoreAgent.SubscribeResponse) throws {
    
}
