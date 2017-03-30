//
//  AuthorisationPresenter.swift
//  DBSwiftMVP
//
//  S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import SwiftyDropbox

protocol AuthorisationListener: class {
    // MARK: - Listener
    func onUserAlreadyAuthorized()
    func onAuthorisationSuccess(token : DropboxAccessToken)
    func onAuthorisationCancel(message: String)
    func onAuthorisationError(error : OAuth2Error, description: String)
    func onDeAuthorisationSuccess()
    func onDeAuthorisationFailure(reason: String)
    func onUserDetailsAcquired(user: Users.FullAccountSerializer.ValueType?)
    func onUserDetailsNotAcquired(error : CallError<VoidSerializer.ValueType>?)
    
}
//MARK: -
class AuthorisationPresenter {
    
    // MARK: - Properties
    private var authorisationInteractor : AuthorisationInteractor!
    internal var authorisationViewController : AuthorisationViewController!
    var cachedUser : Users.FullAccountSerializer.ValueType?
    
    // MARK: - Init
    
    init(viewController : AuthorisationViewController) {
        //Inject the listener into the interactor
        self.authorisationInteractor = AuthorisationInteractor(listener : self)
        //The view controller injected itself
        self.authorisationViewController = viewController
    }
    
    // MARK: - Presenter Methods
    
    func checkIfUserIsAuthorized() -> Bool {
       return  authorisationInteractor.getAuthorizedClient() == nil ?  false : true
       
    }
    
    func attemptAuthorisation (vc : AuthorisationViewController) {
        authorisationInteractor.authorize(vc: vc)
    }
    
    func attemptUnlinking() {
        authorisationInteractor.unAuthorize()
    }
    
    func getAccountDetailsForDisplay(){
        authorisationInteractor.getCurrentAccount()
    }
}
//MARK: -
extension AuthorisationPresenter : AuthorisationListener {
    // MARK: - Listener Methods
    
    internal func onUserDetailsAcquired(user: Users.FullAccountSerializer.ValueType?) {
        self.cachedUser = user
        self.authorisationViewController.showAccountDetails()
    }
    
    internal func onUserDetailsNotAcquired(error: CallError<VoidSerializer.ValueType>?) {
        self.cachedUser = nil
        self.authorisationViewController.hideAccountDetails()
        DropboxClientsManager.authorizedClient = nil
    }
    
    internal func onUserAlreadyAuthorized() {
        self.getAccountDetailsForDisplay()
    }
    
    internal func onAuthorisationSuccess(token: DropboxAccessToken) {
        self.getAccountDetailsForDisplay()
    }

    internal func onAuthorisationError(error : OAuth2Error, description: String) {
        self.authorisationViewController.hideAccountDetails()
    }
    
    internal func onDeAuthorisationSuccess() {
        self.cachedUser = nil
        self.authorisationViewController.hideAccountDetails()
    }

    internal func onAuthorisationCancel(message: String) {
        self.checkIfUserIsAuthorized() ? self.getAccountDetailsForDisplay() : self.authorisationViewController.hideAccountDetails()
    }

    internal func onDeAuthorisationFailure(reason: String) {
        self.checkIfUserIsAuthorized() ? self.getAccountDetailsForDisplay() : self.authorisationViewController.hideAccountDetails()
    }
}
