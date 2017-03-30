//
//  DropboxEntryDetailPresenter.swift
//  DBSwiftMVP
//
//  S.Jan on 29/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
import SwiftyDropbox
protocol DropboxEntryDetailListener : class {
    func onEntryDetailsReceived(metaData : Files.FileMetadata, image : UIImage)
    func onEntryDetailsNotReceived(error : String)
    func onEntryRemoved()
    func onEntryNotRemoved(error: String)
    func onFileDownloaded(metadata : Files.Metadata, url : URL)
    func onFileNotDownloaded(error : CallError<Files.DownloadError>)
    func onDownloadProgressReceived(progress : Progress)

}

class DropboxEntryDetailPresenter {
    
    internal var detailViewController : DropboxEntryDetailViewController!
    internal var entryDetailInteractor : DropboxEntryDetailInteractor!
    internal var entry : DropboxEntryViewObject!
    
    
    
    init(detailViewController : DropboxEntryDetailViewController, entry : DropboxEntryViewObject) {
        self.detailViewController = detailViewController
        self.entryDetailInteractor = DropboxEntryDetailInteractor(listener : self)
        self.entry = entry
    }
    
    func getEntryDetails() -> Void {
        if entry.isImage() {
            entryDetailInteractor.getThumbnail(path: self.entry.pathLower)
        } else if entry.isPreviewable() {
            //get preview
            entryDetailInteractor.getPreview(path: self.entry.pathLower)
           
        } else if !entry.folder {
            detailViewController.showEntryDetails(entry: self.entry)
        }
        else {
            //Not implemented yet
            detailViewController.confrontUser(messages:["Hi", "I'm sorry to tell you...", "but...", "this feature is not implemented yet..", "So maybe you could...", "Stop tapping to get out of this...", "And just close the app and implement it!", "If you are still watching" , "Thank you in advance"], durationPerMessage:1)
        }
        
    }
    
    func downloadEntry() -> Void {
        self.entryDetailInteractor.download(name : self.entry.fileName , path: self.entry.pathLower)
    }
    
    func removeEntry() -> Void {
        self.entryDetailInteractor.delete(path: self.entry.pathLower)
    }
    
}

extension DropboxEntryDetailPresenter : DropboxEntryDetailListener {
    func onDownloadProgressReceived(progress: Progress) {
        let completed =  round(progress.fractionCompleted * 100)
        let color : UIColor!
        
        switch (completed) {
        case 0..<10:
            color = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            break
        case 10..<20:
            color = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            break
        case 20..<40:
            color = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            break
        case 40..<70:
            color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            break
        case 70..<101:
            color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
        default:
            color = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
        self.detailViewController.showProgress(progress : String(completed), color: color)
    }

    func onFileNotDownloaded(error: CallError<Files.DownloadError>) {
        self.detailViewController.showEntryNotDownloaded(reason : error.description)
    }

    func onFileDownloaded(metadata: Files.Metadata, url: URL) {
        self.detailViewController.showEntryDownloaded(location : url.absoluteString)
    }

    func onEntryNotRemoved(error: String) {
        self.detailViewController.showEntryNotRemoved(description : error.description)
    }

    func onEntryRemoved() {
        self.detailViewController.showEntryRemoved()
    }

    func onEntryDetailsNotReceived(error: String) {
        self.detailViewController.showError(description: error)
    }

    func onEntryDetailsReceived(metaData: Files.FileMetadata, image: UIImage) {
        self.entry.setSize(size: Int(metaData.size))
        self.entry.setLastUpdate(date: metaData.serverModified)
        self.entry.objectImage = image
        detailViewController.showEntryDetails(entry: self.entry)
    }

    
    func onEntryDetailsReceived() {
        
    }

    
}
