//
//  GroupStoreReducer.swift
//  UrsusAPI
//
//  Created by Daniel Clelland on 27/11/20.
//

import Foundation

public protocol GroupStoreState {
    
    var groups: Groups { get set }
    
}

public func reduce(_ state: inout GroupStoreState, response: GroupStoreAgent.SubscribeResponse) throws {
    
}
