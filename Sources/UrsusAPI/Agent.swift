//
//  Agent.swift
//  Alamofire
//
//  Created by Daniel Clelland on 27/11/20.
//

import Foundation
import Alamofire
import UrsusHTTP

extension Client {
    
    public func agent<T: Agent>(ship: Ship, app: App) -> T {
        return T(client: self, ship: ship, app: app)
    }
    
}

open class Agent {
    
    public var client: Client
    public var ship: Ship
    public var app: App
    
    required public init(client: Client, ship: Ship, app: App) {
        self.client = client
        self.ship = ship
        self.app = app
    }
    
}

extension Agent {
    
    @discardableResult public func scryRequest(path: Path) -> DataRequest {
        return client.scryRequest(app: app, path: path)
    }
    
    @discardableResult public func spiderRequest(input: Mark, thread: UrsusHTTP.Thread, output: Mark) -> DataRequest {
        return client.spiderRequest(input: input, thread: thread, output: output)
    }
    
}

extension Agent {
    
    @discardableResult public func ackRequest(eventID: Int) -> DataRequest {
        return client.ackRequest(eventID: eventID)
    }
    
    @discardableResult public func pokeRequest<JSON: Encodable>(mark: Mark = "json", json: JSON, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        return client.pokeRequest(ship: ship, app: app, mark: mark, json: json, handler: handler)
    }
    
    @discardableResult public func subscribeRequest(path: Path, handler: @escaping (SubscribeEvent<Data>) -> Void) -> DataRequest {
        return client.subscribeRequest(ship: ship, app: app, path: path, handler: handler)
    }
    
    @discardableResult public func subscribeRequest<JSON: Decodable>(path: Path, handler: @escaping (SubscribeEvent<Result<JSON, Error>>) -> Void) -> DataRequest {
        return client.subscribeRequest(ship: ship, app: app, path: path, handler: handler)
    }
    
    @discardableResult public func unsubscribeRequest(subscriptionID: Int) -> DataRequest {
        return client.channelRequest(subscriptionID)
    }
    
    @discardableResult public func deleteRequest() -> DataRequest {
        return client.deleteRequest()
    }
    
}
