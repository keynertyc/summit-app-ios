//
//  HttpFactory.swift
//  OpenStackSummit
//
//  Created by Claudio on 9/26/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import UIKit
import AeroGearHttp
import AeroGearOAuth2

@objc public enum HttpType: Int {
    case OpenIDGetFormUrlEncoded, OpenIDJson, ServiceAccount
}

public class HttpFactory: NSObject {
    var securityManager: SecurityManager!
    
    public func create(type: HttpType) -> Http {
        let http: Http
        if (type == HttpType.OpenIDGetFormUrlEncoded) {
            http = Http(responseSerializer: StringResponseSerializer())
            http.authzModule = securityManager.oauthModuleOpenID
        }
        else if (type == HttpType.OpenIDJson) {
            http = Http(responseSerializer: StringResponseSerializer(), requestSerializer: JsonRequestSerializer())
            http.authzModule = securityManager.oauthModuleOpenID
        }
        else {
            http = Http(responseSerializer: StringResponseSerializer())
            http.authzModule = securityManager.oauthModuleServiceAccount
        }
        return http
    }
}