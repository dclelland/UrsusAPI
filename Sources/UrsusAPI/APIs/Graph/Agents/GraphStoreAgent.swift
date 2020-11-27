//
//  GraphStoreAgent.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 24/11/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import UrsusHTTP

extension Client {
    
    public func graphStoreAgent(ship: Ship) -> GraphStoreAgent {
        return agent(ship: ship, app: "graph-store")
    }
    
}

public class GraphStoreAgent: Agent {
    
    @discardableResult public func keysSubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/keys", handler: handler)
    }
    
    @discardableResult public func updatesSubscribeRequest(handler: @escaping (SubscribeEvent<Result<SubscribeResponse, Error>>) -> Void) -> DataRequest {
        return subscribeRequest(path: "/updates", handler: handler)
    }
    
    #warning("TODO: Finish GraphStoreAgent")
    
//    private storeAction(action: any): Promise<any> {
//      return this.action('graph-store', 'graph-update', action)
//    }
    
//    addGraph(ship: Patp, name: string, graph: any, mark: any) {
//      return this.storeAction({
//        'add-graph': {
//          resource: { ship, name },
//          graph,
//          mark
//        }
//      });
//    }
    
    public func getKeys() -> DataRequest {
        return scryRequest(path: "/keys")
    }
    
    public func getTags() -> DataRequest {
        return scryRequest(path: "/tags")
    }
    
    public func getTagQueries() -> DataRequest {
        return scryRequest(path: "/tag-queries")
    }
    
    public func getGraph(ship: Ship, resource: Resource) -> DataRequest {
        return scryRequest(path: "/graph/\(Ship.Prefixless(ship))/\(resource.description)")
    }
    
    public func getGraphSubset(ship: Ship, resource: Resource, start: String, end: String) -> DataRequest {
        return scryRequest(path: "/graph-subset/\(Ship.Prefixless(ship))/\(resource.description)/\(end)/\(start)")
    }
    
    public func getNode(ship: Ship, resource: Resource, index: Index) -> DataRequest {
//      const idx = index.split('/').map(numToUd).join('/');
        return scryRequest(path: "/node/\(Ship.Prefixless(ship))/\(resource.description)\(index)")
    }
    
}

extension GraphStoreAgent {
    
    public enum SubscribeResponse: Decodable {
        
        case graphUpdate(GraphUpdate)
        
        enum CodingKeys: String, CodingKey {
            
            case graphUpdate = "graph-update"
            
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch Set(container.allKeys) {
            case [.graphUpdate]:
                self = .graphUpdate(try container.decode(GraphUpdate.self, forKey: .graphUpdate))
            default:
                throw DecodingError.dataCorruptedError(type(of: self), at: decoder.codingPath, in: container)
            }
        }
        
    }
    
}

/*
import BaseApi from './base';
import { StoreState } from '../store/type';
import { Patp, Path, PatpNoSig } from '~/types/noun';
import _ from 'lodash';
import {makeResource, resourceFromPath} from '../lib/group';
import {GroupPolicy, Enc, Post, NodeMap, Content} from '~/types';
import { numToUd, unixToDa } from '~/logic/lib/util';

export const createBlankNodeWithChildPost = (
  parentIndex: string = '',
  childIndex: string = '',
  contents: Content[]
) => {
  const date = unixToDa(Date.now()).toString();
  const nodeIndex = parentIndex + '/' + date;

  const childGraph = {};
  childGraph[childIndex] = {
    post: {
      author: `~${window.ship}`,
      index: nodeIndex + '/' + childIndex,
      'time-sent': Date.now(),
      contents,
      hash: null,
      signatures: []
    },
    children: { empty: null }
  };

  return {
    post: {
      author: `~${window.ship}`,
      index: nodeIndex,
      'time-sent': Date.now(),
      contents: [],
      hash: null,
      signatures: []
    },
    children: {
      graph: childGraph
    }
  };
};

export const createPost = (
  contents: Content[],
  parentIndex: string = '',
  childIndex:string = 'DATE_PLACEHOLDER'
) => {
  if (childIndex === 'DATE_PLACEHOLDER') {
    childIndex = unixToDa(Date.now()).toString();
  }
  return {
    author: `~${window.ship}`,
    index: parentIndex + '/' + childIndex,
    'time-sent': Date.now(),
    contents,
    hash: null,
    signatures: []
  };
};

function moduleToMark(mod: string): string | undefined {
  if(mod === 'link') {
    return 'graph-validator-link';
  }
  if(mod === 'publish') {
    return 'graph-validator-publish';
  }
  return undefined;
}
*/
