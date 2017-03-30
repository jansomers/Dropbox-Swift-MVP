//
//  DropboxEntriesPresenter.swift
//  DBSwiftMVP
//
//  S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyDropbox

protocol DropboxEntriesListener : class {
    //MARK: - Listener
    func onGetEntriesSuccess (entries : [Files.Metadata]?)
    func onGetEntriesError (reason : String)
}
//MARK: -
class DropboxEntriesPresenter {
    
    //MARK: - Properties
    internal var entries = Array<DropboxEntryViewObject>()
    internal var presentedPath : String = ""
    private var dropboxEntriesInteractor : DropboxEntriesInteractor?
    internal var dropboxEntriesTableViewController : DropboxEntriesTableViewController
    
    //MARK - Init
    init(dropboxEntriesTableViewController : DropboxEntriesTableViewController) {
        self.dropboxEntriesTableViewController = dropboxEntriesTableViewController
        self.dropboxEntriesInteractor = DropboxEntriesInteractor(listener : self)
    }
    
    //MARK - Presenter methods
    public func getEntries () ->  Array<DropboxEntryViewObject> {
        return self.entries
    }
    
    public func seedEntries () -> Void {
        self.entries.removeAll()
        dropboxEntriesInteractor?.getDropboxEntries(path: self.presentedPath)
    }
    
    public func getTypeImage(index : Int) -> UIImage {
        let entry = self.entries[index]
        
        return entry.getTypeImage()
    }
    
    public func getFileName(index : Int) -> String {
        return self.entries[index].fileName
    }
    
    public func getStatusImage(index :Int) -> UIImage {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pathComponent = self.entries[index].fileName
        let localurl = directoryURL.appendingPathComponent(pathComponent!)
        if fileManager.fileExists(atPath: localurl.path) {
            return UIImage(named :"checked")!
        } else {
            return UIImage()
        }
    }
}
//MARK: -
extension DropboxEntriesPresenter : DropboxEntriesListener {
    //MARK: - Listener methods
    
    internal func onGetEntriesError(reason: String) {
        self.dropboxEntriesTableViewController.showError(error: reason)
    }

    internal func onGetEntriesSuccess(entries: [Files.Metadata]?) {
        var viewEntries = Array<DropboxEntryViewObject>()
        if (entries?.isEmpty)! {
            self.dropboxEntriesTableViewController.showEmptyFolder()
        
        } else {
            for dropboxEntry in entries! {
                viewEntries.append(DropboxEntryViewObject(fileName: dropboxEntry.name, pathLower: dropboxEntry.pathLower, pathDisplay: dropboxEntry.pathDisplay, parentFolder: dropboxEntry.parentSharedFolderId))
            }
            self.entries = viewEntries
            self.dropboxEntriesTableViewController.showEntries()
        }
    }

    

    
    
}
