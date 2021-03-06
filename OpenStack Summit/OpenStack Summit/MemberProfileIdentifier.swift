//
//  Profile.swift
//  OpenStack Summit
//
//  Created by Alsey Coleman Miller on 6/20/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import struct CoreSummit.PresentationSpeaker
import typealias CoreSummit.Identifier

/// Data type Used the configure the member profile-related View Controllers. 
public enum MemberProfileIdentifier {
    
    case currentUser
    case speaker(Identifier)
    
    public init() {
        
        self = .currentUser
    }
}


public extension MemberProfileIdentifier {
    
    /// Initialize from `PersonListItem`.
    init(speaker: PresentationSpeaker) {
        
        self = .speaker(speaker.identifier)
    }
}