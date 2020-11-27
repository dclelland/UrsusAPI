//
//  MetadataStoreReducer.swift
//  UrsusAPI
//
//  Created by Daniel Clelland on 27/11/20.
//

import Foundation

public protocol MetadataStoreState {
    
    var associations: Associations { get set }
    
}

public func reduce(_ state: inout MetadataStoreState, response: MetadataStoreAgent.SubscribeResponse) throws {
    
}
