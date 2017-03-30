//
//  DropboxEntryDetailViewController.swift
//  DBSwiftMVP
//
//  S.Jan on 29/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit

protocol DropboxEntryDetailViewContract: class {
    //MARK: - Contract
    
    func showEntryDetails(entry: DropboxEntryViewObject)
    func showSucces()
    func showError(description: String)
    func showEntryNotRemoved(description : String)
    func showEntryRemoved()
    func showProgress(progress: String, color : UIColor)
    func showEntryNotDownloaded(reason: String)
    func showEntryDownloaded(location: String)
}
//MARK: -
class DropboxEntryDetailViewController: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet var previewImageView: UIImageView!
    @IBOutlet var previewImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var previewImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var fileNameView: UILabel!
    @IBOutlet var detailsView: UIView!
    @IBOutlet var fileSizeLabel: UILabel!
    @IBOutlet var fileLastmodified: UILabel!
    @IBOutlet var fileLocationLabel: UILabel!
    @IBOutlet var fileTypeIcon: UIImageView!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var downloadButton: UIButton!
    
    //MARK: - Properties
    
    internal var presenter : DropboxEntryDetailPresenter!
    private var entry : DropboxEntryViewObject!
    private let previewString = "Loading a preview"
    private let noPreviewAvailableString = "No preview available"
    private let unknownDateString = "Unknown date"
    private let removingEntryString = "Removing the entry"
    private let downloadingEntryString = "Downloading..."
    private let preferedHeightConstraintForImage = 210 as CGFloat
    private let preferedWidthConstraintForImage = 148 as CGFloat
    
    //MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = DropboxEntryDetailPresenter(detailViewController : self , entry: self.entry)
        //Storyboard still doesn't let me add an action to a view :( - XCODE why don't you allow this -
        let tapImage = UITapGestureRecognizer(target: self, action:#selector(userTappedPreview))
        previewImageView.addGestureRecognizer(tapImage)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.show(previewString, animated: true)
        self.presenter.getEntryDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setEntryViewObject(entry : DropboxEntryViewObject){
        self.entry = entry
    }
    
    //MARK: - User Actions
    
    func userTappedPreview(sender : Any){
        if self.previewImageViewHeightConstraint.constant == preferedHeightConstraintForImage {
            self.previewImageViewHeightConstraint.constant = self.previewImageViewHeightConstraint.constant * 2
            self.previewImageViewWidthConstraint.constant  = self.previewImageViewWidthConstraint.constant * 2
            self.detailsView.isHidden = true;
        } else {
            self.previewImageViewHeightConstraint.constant = self.previewImageViewHeightConstraint.constant / 2
            self.previewImageViewWidthConstraint.constant  = self.previewImageViewWidthConstraint.constant / 2
            self.detailsView.isHidden = false;
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func userPressedRemove(_ sender: Any) {
        SwiftSpinner.show(removingEntryString, animated: true)
        self.presenter.removeEntry()
    }
    
    @IBAction func userPressedDownload(_ sender: Any) {
        SwiftSpinner.show(downloadingEntryString, animated: true)
        self.presenter.downloadEntry()
    }
    
    //MARK: - Contract methods
    
    func showEntryDetails(entry : DropboxEntryViewObject){
        self.fileNameView.text = entry.fileName
        self.fileSizeLabel.text = entry.size != nil ? entry.size : noPreviewAvailableString
        self.fileTypeIcon.image = entry.getTypeImage()
        self.fileLastmodified.text = entry.lastUpdate != nil ? entry.lastUpdate : unknownDateString
        self.fileLocationLabel.text = entry.pathDisplay
        
        if let previewImage = entry.objectImage {
            self.previewImageViewHeightConstraint.constant = self.preferedHeightConstraintForImage
            self.previewImageViewWidthConstraint.constant = self.preferedWidthConstraintForImage
            self.previewImageView.image = previewImage
        } else {
            self.previewImageViewHeightConstraint.constant = 0
            self.previewImageViewWidthConstraint.constant = 0
            self.previewImageView.image = UIImage()
        }
        self.showSuccess()
        self.previewImageView.isHidden = false
        self.detailsView.isHidden = false
        self.view.layoutIfNeeded()
    }
    
    func showSuccess() {
        if SwiftSpinner.sharedInstance.animating {
            SwiftSpinner.sharedInstance.title = "Sucess"
            SwiftSpinner.sharedInstance.titleLabel.textColor = UIColor.green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                SwiftSpinner.hide()
            })
        }
    }
    
    func showError(description: String) {
        if SwiftSpinner.sharedInstance.animating {
            SwiftSpinner.sharedInstance.title = "Error"
            SwiftSpinner.sharedInstance.subtitleLabel?.text = description
            SwiftSpinner.sharedInstance.titleLabel.textColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                SwiftSpinner.hide()
            })
        }
    }

    func showEntryNotRemoved(description : String) {
        self.showError(description: description)
    }
    func showEntryRemoved() {
        self.showSuccess()
        self.navigationController?.popViewController(animated: true)
    }
    
    func showProgress(progress: String, color : UIColor) {
        if SwiftSpinner.sharedInstance.animating {
            SwiftSpinner.sharedInstance.title = progress
            SwiftSpinner.sharedInstance.titleLabel.textColor = color
        }
    }
    
    func showEntryNotDownloaded(reason: String){
        self.showError(description: reason)
    }
    
    func showEntryDownloaded(location: String){
        if SwiftSpinner.sharedInstance.animating {
            SwiftSpinner.sharedInstance.subtitleLabel?.text = "File location : " + location
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.showSuccess()
            self.downloadButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
                self.downloadButton.isEnabled = true
            })
        })
    }
    
    func confrontUser(messages : [String], durationPerMessage : Int) {
        var i = 0
        var waitTime : Double
        for message in messages {
            i += 1
            waitTime = Double(i * durationPerMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + waitTime, execute: {
                SwiftSpinner.sharedInstance.titleLabel.text = message
                if i%2 == 0 {
                    SwiftSpinner.sharedInstance.titleLabel.textColor = UIColor.purple
                } else if i%3 == 0 {
                    SwiftSpinner.sharedInstance.titleLabel.textColor = UIColor.yellow
                } else {
                    SwiftSpinner.sharedInstance.titleLabel.textColor = UIColor.orange
                }
                if message == messages[messages.count - 1]{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        SwiftSpinner.hide()
                    })
                }
            })
        }
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
