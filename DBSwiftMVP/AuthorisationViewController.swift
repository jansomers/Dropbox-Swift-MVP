    //
//  AuthorisationViewController.swift
//  DBSwiftMVP
//
//  S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
import SwiftyDropbox


protocol AuthorisationContract {
    // MARK: Contract 
    func showAccountDetails() -> Void
    func hideAccountDetails() -> Void
}
// MARK:
class AuthorisationViewController: UIViewController, AuthorisationContract {

    // MARK: - Outlets
    @IBOutlet var authorizeButton: UIButton!
    @IBOutlet var deAuthorizeButton: UIButton!
    @IBOutlet var accountDetailsLabel: UIView!
    @IBOutlet var accountContinueButton: UIButton!
    @IBOutlet var accountNameLabel: UILabel!
    
    // MARK: - properties
    private var presenter : AuthorisationPresenter!
    
    // MARK: - View Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Inject the viewController in the presenter
        presenter = AuthorisationPresenter(viewController : self)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.presenter.checkIfUserIsAuthorized() {
             self.showAutoAuthorisation()
        } else {
            presenter.attemptAuthorisation(vc: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions

    @IBAction func userPressedAuthorize(_ sender: UIButton) {
        if !SwiftSpinner.sharedInstance.animating {
            SwiftSpinner.show("Authorizing", animated: true)
        }
        SwiftSpinner.sharedInstance.title = "Authorizing"
        SwiftSpinner.sharedInstance.subtitleLabel?.text = "Please wait"
        presenter.attemptAuthorisation(vc: self)
    }
    
    @IBAction func userPressedDeAuthorize(_ sender: UIButton) {
        presenter.attemptUnlinking()
    }
    
    @IBAction func userPressedContinueToAccount(_ sender: UIButton) {
        let accountViewController = storyboard?.instantiateViewController(withIdentifier: "accountVC") as! AccountViewController
        accountViewController.setUser(user: self.presenter.cachedUser)
        self.navigationController?.pushViewController(accountViewController, animated: true)
    }
    
    // MARK: - Contract Methods
   
    func showAccountDetails() {
        if SwiftSpinner.sharedInstance.animating{
            SwiftSpinner.sharedInstance.title = "Authorized"
             SwiftSpinner.sharedInstance.titleLabel.textColor = UIColor.green
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if SwiftSpinner.sharedInstance.animating {
                SwiftSpinner.hide()
            }
        })
        self.accountDetailsLabel.isHidden = false
        self.accountNameLabel.text = self.presenter.cachedUser?.email
        self.accountContinueButton.isHidden = false
        self.authorizeButton.isEnabled = false
        self.deAuthorizeButton.isEnabled = true
    }
    
    func hideAccountDetails() {
        if SwiftSpinner.sharedInstance.animating{
            SwiftSpinner.sharedInstance.title = "Not Authorized"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if SwiftSpinner.sharedInstance.animating {
                SwiftSpinner.hide()
            }
        })
        self.accountContinueButton.isHidden = true
        self.accountNameLabel.text = ""
        self.accountDetailsLabel.isHidden = true
        self.deAuthorizeButton.isEnabled = false
        self.authorizeButton.isEnabled = true
    }
    
    
    func showAutoAuthorisation() -> Void {
        SwiftSpinner.show(duration: 5, title: "Automating authorisation", animated: true).addTapHandler({
            SwiftSpinner.hide()
        },subtitle: "Tap to cancel auto authorisation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if SwiftSpinner.sharedInstance.animating {
                SwiftSpinner.sharedInstance.title = "4.."
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            if SwiftSpinner.sharedInstance.animating {
                SwiftSpinner.sharedInstance.title = "3.."
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            if SwiftSpinner.sharedInstance.animating {
                SwiftSpinner.sharedInstance.title = "2.."
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            if SwiftSpinner.sharedInstance.animating {
                SwiftSpinner.sharedInstance.title = "1.."
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            if SwiftSpinner.sharedInstance.animating {
                SwiftSpinner.sharedInstance.clearTapHandler()
                self.userPressedAuthorize(self.authorizeButton)
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
