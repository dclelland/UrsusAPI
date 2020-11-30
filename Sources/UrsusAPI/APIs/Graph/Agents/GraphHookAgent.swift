//
//  GraphHookAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/11/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusHTTP

extension Client {
    
    public func graphHookAgent(ship: Ship, state: ContactViewAgent.State = .init()) -> GraphHookAgent {
        return agent(ship: ship, app: "graph-push-hook", state: state)
    }
    
}

public class GraphHookAgent: Agent<GraphHookAgent.State, GraphHookAgent.Request> {
    
    public struct State: AgentState { }
    
    public enum Request: AgentRequest { }
    
    #warning("TODO: Finish GraphHookAgent")
    
//    private hookAction(ship: Patp, action: any): Promise<any> {
//      return this.action('graph-push-hook', 'graph-update', action);
//    }
    
//    addPost(ship: Patp, name: string, post: Post) {
//      let nodes = {};
//      const resource = { ship, name };
//      nodes[post.index] = {
//        post,
//        children: { empty: null }
//      };
//
//      return this.hookAction(ship, {
//        'add-nodes': {
//          resource,
//          nodes
//        }
//      });
//    }
//
//    addNode(ship: Patp, name: string, node: Object) {
//      let nodes = {};
//      const resource = { ship, name };
//      nodes[node.post.index] = node;
//
//      return this.hookAction(ship, {
//        'add-nodes': {
//          resource,
//          nodes
//        }
//      });
//    }
//
//    addNodes(ship: Patp, name: string, nodes: Object) {
//      return this.hookAction(ship, {
//        'add-nodes': {
//          resource: { ship, name },
//          nodes
//        }
//      });
//    }
//
//    removeNodes(ship: Patp, name: string, indices: string[]) {
//      return this.hookAction(ship, {
//        'remove-nodes': {
//          resource: { ship, name },
//          indices
//        }
//      });
//    }
    
}
