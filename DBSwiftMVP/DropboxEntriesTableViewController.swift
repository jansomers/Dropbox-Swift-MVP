//
//  DropboxEntriesTableViewController.swift
//  DBSwiftMVP
//
//  S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit

protocol DropboxEntriesOverViewContract : class {
    //MARK: - Contract
    func showEntries()
    func showEmptyFolder()
    func showError(error: String)
    func showSuccess()
}
//NOTE: Only the root folder is implemented, due to time restrictions
//MARK: -
class DropboxEntriesTableViewController: UITableViewController, DropboxEntriesOverViewContract {
    
    //MARK: - Properties
    
    private var presenter : DropboxEntriesPresenter?
    private let cellIdentifier = "overviewCell"
    private let detailViewControllerIdentifier = "detailVC"
    private let loadingFilesString = "Loading files..."
    private let successString = "Success"
    //MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = DropboxEntriesPresenter(dropboxEntriesTableViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
        SwiftSpinner.show(loadingFilesString, animated: true)
        
        self.presenter?.seedEntries()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.presenter!.getEntries().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DropboxEntryOverviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DropboxEntryOverviewTableViewCell
        cell.typeImage.image = self.presenter?.getTypeImage(index : indexPath.row)
        cell.nameLabel.text = self.presenter?.getFileName(index : indexPath.row)
        cell.optionImage.image = self.presenter?.getStatusImage(index : indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: detailViewControllerIdentifier) as! DropboxEntryDetailViewController
        detailViewController.setEntryViewObject(entry: (self.presenter?.getEntries()[indexPath.row])!)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    //MARK: - User Actions
    
    @IBAction func backWasPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Contract methods
    
    public func showEntries() -> Void {
        SwiftSpinner.sharedInstance.title = successString
        SwiftSpinner.sharedInstance.titleLabel.textColor = UIColor.green
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            SwiftSpinner.hide()
        })
        self.tableView.reloadData()
    }
    
    public func showEmptyFolder() -> Void {
        self.showError(error: "Empty dropbox")
        let alert = UIAlertController(title: "No files", message: "Your Dropbox is empty", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "I'll add some and come back", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(error: String) {
//        self.showError(error: error)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            let alert = UIAlertController(title: "Getting entries error", message: "Error: " + error, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "I'll fix it and come back ", style: UIAlertActionStyle.cancel, handler: { (alert: UIAlertAction!) in
                self.showErrorSpinner(description: error)
                
            }))
            self.present(alert, animated: true, completion: nil)

        })
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
    
    func showErrorSpinner(description: String) {
        if SwiftSpinner.sharedInstance.animating {
            SwiftSpinner.sharedInstance.title = "Error"
            SwiftSpinner.sharedInstance.subtitleLabel?.text = description
            SwiftSpinner.sharedInstance.titleLabel.textColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                SwiftSpinner.hide()
            })
        }
    }
}
