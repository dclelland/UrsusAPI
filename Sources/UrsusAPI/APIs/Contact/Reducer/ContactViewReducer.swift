//
//  ContactViewReducer.swift
//  UrsusAPI
//
//  Created by Daniel Clelland on 27/11/20.
//

import Foundation

public protocol ContactViewState {
    
    var contacts: Rolodex { get set }
    
}

public func reduce(_ state: inout ContactViewState, response: ContactViewAgent.SubscribeResponse) throws {
    
}
