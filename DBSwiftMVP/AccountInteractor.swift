//
//  AccountInteractor.swift
//  DBSwiftMVP
//
//  S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
import SwiftyDropbox
class AccountInteractor: NSObject {
    //MARK: - Properties
    
    weak var listener : AccountListener?
    
    //MARK: - Init
    
    init (listener : AccountListener) {
        self.listener = listener
    }
    
    //MARK: - User Api Methods
    
    func revoke(){
        if let client = DropboxClientsManager.authorizedClient {
            client.auth.tokenRevoke().response(completionHandler: {
                response , error in
                if error == nil {
                    self.listener?.onTokenRevoked()
                    
                }
                else {
                    self.listener?.onTokenRevokedError(reason: (error?.description)!)
                }
            })
            
        } else {
            //No client, huh?
        }
        
        
    }
}
