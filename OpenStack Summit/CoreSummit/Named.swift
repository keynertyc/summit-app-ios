//
//  Named.swift
//  OpenStackSummit
//
//  Created by Alsey Coleman Miller on 5/31/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

/// A named data type.
public protocol Named: Unique {
    
    var name: String { get }
}
