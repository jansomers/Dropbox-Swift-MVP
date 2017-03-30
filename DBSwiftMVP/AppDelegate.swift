//
//  AppDelegate.swift
//  DBSwiftMVP
//
//  Created by S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
import CoreData
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //Remove only if you are Batman or Bane
    var window: UIWindow?
    
    //We will keep a pointer to the Authorisationlistener in our Appdelegate, since we leave to app to sign in to Dropbox but still need to be able to fire our callbacks.
    var authorisationListener : AuthorisationListener?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DropboxClientsManager.setupWithAppKey("qi6a22q3omlvouo")
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        //An authorisation can either complete, fail, or get cancelled.
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success(let token):
                //In this project I only implemented automatic authorizsation, but using this token, you can also handle everything manually.
                self.authorisationListener?.onAuthorisationSuccess(token: token)
            case .cancel:
                self.authorisationListener?.onAuthorisationCancel(message : "Canceled Authorisation")
            case .error(let error, let description):
                self.authorisationListener?.onAuthorisationError(error : error, description : description)
            }
        }
        return false
    }
   
}

