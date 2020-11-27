//
//  ContactViewReducer.swift
//  UrsusAPI
//
//  Created by Daniel Clelland on 27/11/20.
//

import Foundation
import UrsusHTTP

public protocol ContactViewState {
    
    var contacts: Rolodex { get set }
    
}

public func reduce(_ state: inout ContactViewState, _ response: ContactViewAgent.SubscribeResponse) throws {
    switch response {
    case .contactUpdate(let update):
        switch update {
        case .initial(let initial):
            state.contacts = initial.mapValues { contacts in
                return Dictionary(
                    uniqueKeysWithValues: contacts.compactMap { ship, contact in
                        return (try? Ship(string: ship)).map { ship in
                            return (ship, contact)
                        }
                    }
                )
            }
        case .create(let create):
            state.contacts[create] = [:]
        case .delete(let delete):
            state.contacts[delete] = nil
        case .add(let add):
            state.contacts[add.path]?[add.ship] = add.contact
        case .remove(let remove):
            state.contacts[remove.path]?[remove.ship] = nil
        case .edit(let edit):
            switch edit.editField {
            case .nickname(let nickname):
                state.contacts[edit.path]?[edit.ship]?.nickname = nickname
            case .email(let email):
                state.contacts[edit.path]?[edit.ship]?.email = email
            case .phone(let phone):
                state.contacts[edit.path]?[edit.ship]?.phone = phone
            case .website(let website):
                state.contacts[edit.path]?[edit.ship]?.website = website
            case .notes(let notes):
                state.contacts[edit.path]?[edit.ship]?.notes = notes
            case .color(let color):
                state.contacts[edit.path]?[edit.ship]?.color = color
            case .avatar(let avatar):
                state.contacts[edit.path]?[edit.ship]?.avatar = avatar
            }
        case .contacts:
            break
        }
    }
}
