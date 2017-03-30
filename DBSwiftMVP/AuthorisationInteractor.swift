//
//  AuthorisationInteractor.swift
//  DBSwiftMVP
//
//  S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
import SwiftyDropbox


class AuthorisationInteractor {
    
    // MARK: - Properties
    
    weak var listener : AuthorisationListener?
    
    // MARK: - Init
    
    init (listener : AuthorisationListener) {
        self.listener = listener;
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.authorisationListener = self.listener
    }
    
    // MARK: - Api methods
    
    public func getAuthorizedClient() -> DropboxClient? {
        return DropboxClientsManager.authorizedClient
    }
    
    public func authorize(vc : AuthorisationViewController) -> Void {
        if (getAuthorizedClient() == nil) {
            DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: vc, openURL: { (url: URL) -> Void in
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    succes in
                    if succes {
                        // Well hooray it loaded
                    } else {
                        // Oh damn
                    }
                })
            }, browserAuth: false)
        } else {
            listener?.onUserAlreadyAuthorized()
        }
       
    }
    
    public func unAuthorize() -> Void {
        if (getAuthorizedClient() != nil) {
            DropboxClientsManager.unlinkClients()
            listener?.onDeAuthorisationSuccess()
        } else {
            listener?.onDeAuthorisationFailure(reason: "No authorized user")
        }
    }
    
    public func getCurrentAccount() -> Void {
        let client = DropboxClientsManager.authorizedClient
        _ = client?.users.getCurrentAccount().response(completionHandler: {
            (user, error) in
            if (user != nil) {
                self.listener?.onUserDetailsAcquired(user: user)
            }
            else {
                self.listener?.onUserDetailsNotAcquired(error : error)
            }
        })

    }
  
}
