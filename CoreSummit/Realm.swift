//
//  Realm.swift
//  OpenStackSummit
//
//  Created by Alsey Coleman Miller on 5/31/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import RealmSwift

/// To use as a type contraint
public protocol RealmEntityProtocol: class { }

public class RealmEntity: Object, RealmEntityProtocol {
    
    public dynamic var id = 0
    
    public override class func primaryKey() -> String {
        return "id"
    }
}

public protocol RealmDecodable {
    
    init(realm: RealmEntity)
}

public protocol RealmEncodable {
    
    
}