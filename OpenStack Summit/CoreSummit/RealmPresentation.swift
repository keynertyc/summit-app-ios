//
//  RealmPresentation.swift
//  OpenStackSummit
//
//  Created by Alsey Coleman Miller on 6/2/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import RealmSwift

public class RealmPresentation: RealmEntity {
    
    public dynamic var level = ""
    public dynamic var track: RealmTrack?
    public dynamic var moderator: RealmPresentationSpeaker?
    public let speakers = List<RealmPresentationSpeaker>()
    
    /*
    public var event: RealmSummitEvent {
        return self.linkingObjects(RealmSummitEvent.self, forProperty: "presentation").first!
    }*/
}

// MARK: - Encoding

extension Presentation: RealmDecodable {
    
    public init(realmEntity: RealmPresentation) {
        
        self.identifier = realmEntity.id
        self.level = Level(rawValue: realmEntity.level)
        self.track = realmEntity.track?.id
        self.moderator = realmEntity.moderator?.id
        self.speakers = realmEntity.speakers.identifiers
    }
}

extension Presentation: RealmEncodable {
    
    public func save(realm: Realm) -> RealmPresentation {
        
        let realmEntity = RealmType.cached(identifier, realm: realm)
        
        realmEntity.level = level?.rawValue ?? ""
        realmEntity.speakers.replace(with: speakers)
        
        if let moderatorIdentifier = self.moderator {
            
            realmEntity.moderator = RealmPresentationSpeaker.cached(moderatorIdentifier, realm: realm)
            
        } else {
            
            realmEntity.moderator = nil
        }
        
        if let trackIdentifier = self.track {
            
            realmEntity.track = RealmTrack.cached(trackIdentifier, realm: realm)
            
        } else {
            
            realmEntity.track = nil
        }
        
        return realmEntity
    }
}
