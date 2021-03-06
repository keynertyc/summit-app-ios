//
//  RealmPresentationSpeaker.swift
//  OpenStackSummit
//
//  Created by Alsey Coleman Miller on 5/31/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import RealmSwift

public class RealmPresentationSpeaker: RealmPerson {
    
    /*
    public var presentations: [RealmPresentation] {
        
        return self.linkingObjects(RealmPresentation.self, forProperty: "speakers")
    }*/
    
}

// MARK: - Fetches

public extension PresentationSpeaker {
    
    static var sortProperties: [SortDescriptor] {
        
        return [SortDescriptor(property: "firstName", ascending: true),
                SortDescriptor(property: "lastName", ascending: true)]
    }
    
    static func filter(searchTerm: String, page: Int, objectsPerPage: Int, realm: Realm = Store.shared.realm) -> [PresentationSpeaker] {
        
        var result = realm.objects(RealmPresentationSpeaker.self).sorted(PresentationSpeaker.sortProperties)
        
        // HACK: filter speakers with empty name
        result = result.filter("firstName != '' || lastName != ''")
        
        if searchTerm.isEmpty == false {
            
            result = result.filter("firstName CONTAINS [c] %@ or lastName CONTAINS [c] %@", searchTerm, searchTerm)
        }
        
        var speakers = [RealmPresentationSpeaker]()
        
        let startRecord = (page - 1) * objectsPerPage
        
        let endRecord = (startRecord + (objectsPerPage - 1)) <= result.count ? startRecord + (objectsPerPage - 1) : result.count - 1
        
        if (startRecord <= endRecord) {
            
            for index in (startRecord...endRecord) {
                speakers.append(result[index])
            }
        }
        
        return PresentationSpeaker.from(realm: speakers)
    }
}

// MARK: - Encoding

extension PresentationSpeaker: RealmDecodable {
    
    public init(realmEntity: RealmPresentationSpeaker) {
        
        // person
        self.identifier = realmEntity.id
        self.firstName = realmEntity.firstName
        self.lastName = realmEntity.lastName
        self.title = realmEntity.title
        self.pictureURL = realmEntity.pictureUrl
        
        // optional
        self.twitter = realmEntity.twitter.isEmpty ? nil : realmEntity.twitter
        self.irc = realmEntity.irc.isEmpty ? nil : realmEntity.irc
        self.title = realmEntity.title.isEmpty ? nil : realmEntity.title
        self.biography = realmEntity.bio.isEmpty ? nil : realmEntity.bio
        
        // speaker
        self.memberIdentifier = realmEntity.memberId == 0 ? nil : realmEntity.memberId
    }
}

extension PresentationSpeaker: RealmEncodable {
    
    public func save(realm: Realm) -> RealmPresentationSpeaker {
        
        let realmEntity = RealmType.cached(identifier, realm: realm)
        
        realmEntity.firstName = firstName
        realmEntity.lastName = lastName
        realmEntity.title = title ?? ""
        realmEntity.pictureUrl = pictureURL
        realmEntity.twitter = twitter ?? ""
        realmEntity.irc = irc ?? ""
        realmEntity.bio = biography ?? ""
        
        realmEntity.memberId = memberIdentifier ?? 0
        
        return realmEntity
    }
}