//
//  AccountPresenter.swift
//  DBSwiftMVP
//
//  S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
import SwiftyDropbox

protocol AccountListener : class {
    //MARK: - Listener
    func onAccountChanged()
    func onTokenRevoked()
    func onTokenRevokedError(reason: String)
}
//MARK: -
class AccountPresenter {
    //MARK: - Properties
    private var accountInteractor : AccountInteractor!
    var accountViewController : AccountViewController?
    var user: Users.FullAccountSerializer.ValueType?
    
    //MARK: - Init
    init(accountViewController : AccountViewController, user : Users.FullAccountSerializer.ValueType? ) {
        self.accountViewController = accountViewController
        self.user = user
        self.accountInteractor = AccountInteractor(listener : self)
    }
    
    //MARK: - Presenter Methods
    func revokeMe(){
        self.accountInteractor.revoke()
    }
}

//MARK: -
extension AccountPresenter : AccountListener {
    func onTokenRevokedError(reason: String) {
        self.accountViewController?.showError(error: reason)
    }

    func onTokenRevoked() {
        self.accountViewController?.showTokenRevoked()
    }

    //MARK: - Listener Methods
    internal func onAccountChanged() {
        //Unimplemented
    }

    
}
