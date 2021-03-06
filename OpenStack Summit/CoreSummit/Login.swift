//
//  Login.swift
//  OpenStack Summit
//
//  Created by Alsey Coleman Miller on 6/21/16.
//  Copyright © 2016 OpenStack. All rights reserved.
//

import SwiftFoundation
import RealmSwift
import AeroGearHttp
import AeroGearOAuth2

public extension Store {
    
    /// The member that is logged in. Only valid for confirmed attendees.
    var authenticatedMember: RealmMember? {
        
        guard let session = self.session,
            let sessionMember = session.member,
            case let .attendee(memberID) = sessionMember,
            let member = RealmMember.find(memberID, realm: self.realm)
            else { return nil }
        
        return member
    }
    
    var isLoggedIn: Bool {
        
        return self.session?.member != nil
    }
    
    var isLoggedInAndConfirmedAttendee: Bool {
        
        guard let session = self.session,
            let sessionMember = session.member,
            case .attendee(_) = sessionMember
            else { return false }
        
        return true
    }
    
    /// Login via OAuth with OpenStack ID
    func login(summit: Identifier? = nil, loginCallback: () -> (), completion: (ErrorValue<()>) -> ()) {
        
        oauthModuleOpenID.login { (accessToken: AnyObject?, claims: OpenIDClaim?, error: NSError?) in // [1]
            
            guard error == nil
                else { completion(.Error(error!)) ; return }
            
            loginCallback()
            
            self.linkAttendee(completion: completion)
        }
    }
    
    /// Complete the Login process and store the session info. 
    func linkAttendee(summit: Identifier? = nil, completion: (ErrorValue<()>) -> ()) {
        
        @inline(__always)
        func success(name name: String, member: SessionMember) {
            
            self.session?.name = name
            self.session?.member = member
            
            completion(.Value())
            
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.LoggedIn.rawValue, object: self)
        }
        
        @inline(__always)
        func failure(error: ErrorType) {
            
            completion(.Error(error))
        }
        
        // link attendee
        
        self.loggedInMember(summit) { (response) in
            
            switch response {
                
            case let .Error(error):
                
                // get non confirmed attendee
                guard (error as NSError).code != 404 else {
                    
                    self.loggedInAttendee() { (response) in
                        
                        switch response {
                            
                        case let .Error(error):
                            
                            failure(error)
                            
                        case let .Value(name):
                            
                            success(name: name, member: .nonConfirmedAttendee)
                        }
                    }
                    
                    return
                }
                
                failure(error)
                
            case let .Value(member):
                
                try! self.realm.write { member.save(self.realm) }
                
                success(name: member.name, member: .attendee(member.identifier))
            }
        }
    }
    
    func logout() {
        
        session?.clear()
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.LoggedOut.rawValue, object: self)
    }
}
