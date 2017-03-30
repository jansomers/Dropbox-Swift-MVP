//
//  AccountViewController.swift
//  DBSwiftMVP
//
//  S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
import SwiftyDropbox

protocol AccountViewContract: class {
    //MARK: - Contract
    
    func showTokenRevoked()
    func showError(error: String)
}
//MARK: -
class AccountViewController: UIViewController, AccountViewContract {
    //MARK: - Outlets
    
    @IBOutlet var accountNameLabel: UILabel!
    
    //MARK: - Properties
    
    internal var presenter : AccountPresenter?
    private var user: Users.FullAccountSerializer.ValueType?
    
    //MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = AccountPresenter(accountViewController: self, user: self.user)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.accountNameLabel.text = self.presenter?.user?.name.displayName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUser(user: Users.FullAccountSerializer.ValueType?){
        self.user = user
    }
    
    
    
    @IBAction func userPressedRevoke(_ sender: Any) {
        SwiftSpinner.show("Revoking token")
        self.presenter?.revokeMe()
    }
    
    func showTokenRevoked() {
        if SwiftSpinner.sharedInstance.animating {
            SwiftSpinner.sharedInstance.title = "Token Revoked"
            SwiftSpinner.sharedInstance.titleLabel.textColor = UIColor.green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                SwiftSpinner.hide()
            })
        }

    }
    func showError(error: String) {
        SwiftSpinner.hide()
        let alert = UIAlertController(title: "Token revoke error", message: "Error: " + error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "I'll fix it and come back ", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
