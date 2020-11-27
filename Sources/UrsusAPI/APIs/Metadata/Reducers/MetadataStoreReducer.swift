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

public func reduce(_ state: inout MetadataStoreState, _ response: MetadataStoreAgent.SubscribeResponse) throws {
    switch response {
    case .metadataUpdate(let update):
        switch update {
        case .initial(let initial):
            state.associations = [:]
            for association in initial.values {
                state.associations[association.appName, default: [:]][association.appPath] = association
            }
        case .add(let add):
            state.associations[add.appName, default: [:]][add.appPath] = add
        case .update(let update):
            state.associations[update.appName, default: [:]][update.appPath] = update
        case .remove(let remove):
            state.associations[remove.appName]?[remove.appPath] = nil
        }
    }
}
