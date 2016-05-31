//
//  Person.swift
//  OpenStackSummit
//
//  Created by Alsey Coleman Miller on 5/31/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

public typealias SummitAttendee = Person

public struct Person: PersonListItemProtocol {
    
    public let identifier: String
    public var name: String
    
    public var title: String
    public var pictureURL: String
    public var attendee: Bool
    public var speaker: Bool
    
    public var location: String
    public var email: String
    public var twitter: String
    public var irc: String
    public var biography: String
}