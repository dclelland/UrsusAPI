# Ursus API

An Urbit API/`%gall` agent client for iOS/macOS in Swift.

See my [Ursus Chat](https://github.com/dclelland/UrsusChat) repository for a demo project.

## Installation

Ursus can be installed using Cocoapods by adding the following line to your podfile:

```ruby
pod 'UrsusAPI', '~> 0.1'
```

I can probably help set up Carthage or Swift Package Manager support if you need it.

## Todo list

Things that would make this codebase nicer:

- [ ] Convert agent to a protocol; rename to UrbitApp?
- [ ] Figure out how to unify agents; agent pokes/subscribes; state; reducers; review thunks up in the main app
    - [ ] `URLRequest` implementing `AgentRequest` (`AppRequest`?) enum type thing idea
- [ ] Add special `Index` and `OrderedDictionary` types
- [ ] Finish all clients up to spec 
- [ ] Split clients into separate subspecs
- [ ] Better documentation/examples.

## Dependencies

- [UrsusHTTP](https://github.com/dclelland/UrsusHTTP)
