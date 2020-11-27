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

public func reduce(_ state: inout GroupStoreState, _ response: GroupStoreAgent.SubscribeResponse) throws {
    switch response {
    case .groupUpdate(let update):
        switch update {
        case .initial(let initial):
            state.groups = initial
        case .addGroup(let addGroup):
            state.groups[addGroup.resource.path] = Group(
                hidden: addGroup.hidden,
                tags: [:],
                members: [],
                policy: addGroup.policy
            )
        case .addMembers(let addMembers):
            for ship in addMembers.ships {
                state.groups[addMembers.resource.path]?.members.insert(ship)
            }
        case .removeMembers(let removeMembers):
            for ship in removeMembers.ships {
                state.groups[removeMembers.resource.path]?.members.remove(ship)
            }
        case .addTag:
            break
        case .removeTag:
            break
        case .changePolicy(let changePolicy):
            switch (state.groups[changePolicy.resource.path]?.policy, changePolicy.diff) {
            case (.open(var policy), .open(.allowRanks(let diff))):
                policy.banRanks = policy.banRanks.subtracting(diff)
                state.groups[changePolicy.resource.path]?.policy = .open(policy)
            case (.open(var policy), .open(.banRanks(let diff))):
                policy.banRanks = policy.banRanks.union(diff)
                state.groups[changePolicy.resource.path]?.policy = .open(policy)
            case (.open(var policy), .open(.allowShips(let diff))):
                policy.banned = policy.banned.subtracting(diff)
                state.groups[changePolicy.resource.path]?.policy = .open(policy)
            case (.open(var policy), .open(.banShips(let diff))):
                policy.banned = policy.banned.union(diff)
                state.groups[changePolicy.resource.path]?.policy = .open(policy)
            case (.invite(var policy), .invite(.addInvites(let diff))):
                policy.pending = policy.pending.union(diff)
                state.groups[changePolicy.resource.path]?.policy = .invite(policy)
            case (.invite(var policy), .invite(.removeInvites(let diff))):
                policy.pending = policy.pending.subtracting(diff)
                state.groups[changePolicy.resource.path]?.policy = .invite(policy)
            case (_, .replace(let diff)):
                state.groups[changePolicy.resource.path]?.policy = diff
            default:
                break
            }
        case .removeGroup(let removeGroup):
            state.groups[removeGroup.resource.path] = nil
        case .expose:
            break
        case .initialGroup(let initialGroup):
            state.groups[initialGroup.resource.path] = initialGroup.group
        }
    }
}
