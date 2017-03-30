//
//  DropboxEntryDetailInteractor.swift
//  DBSwiftMVP
//
//  S.Jan on 29/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
import SwiftyDropbox
class DropboxEntryDetailInteractor {

    
    internal weak var listener : DropboxEntryDetailListener!
    
    init(listener : DropboxEntryDetailListener){
        self.listener = listener
    }
    
    func getThumbnail(path: String){
        if let client = DropboxClientsManager.authorizedClient {
            
            let destination : (URL, HTTPURLResponse) -> URL = {
                temporaryURL, response in
                let fileManager = FileManager.default
                let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                let UUID = Foundation.UUID().uuidString
                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                return directoryURL.appendingPathComponent(pathComponent)
            }
            
            client.files.getThumbnail(path: path, format: .png, size: .w640h480, destination: destination).response { response, error in
                if let (metadata, url) = response {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            self.listener.onEntryDetailsReceived(metaData : metadata, image : image)
                        }
                    }
                }
                else {
                    print("Error downloading file from Dropbox: \(error!)")
                }
            }
        }
    }
    
    func getPreview(path: String){
        if let client = DropboxClientsManager.authorizedClient {
            
            let destination : (URL, HTTPURLResponse) -> URL = {
                temporaryURL, response in
                let fileManager = FileManager.default
                let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                let UUID = Foundation.UUID().uuidString
                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                return directoryURL.appendingPathComponent(pathComponent)
            }
            
            client.files.getPreview(path: path, destination: destination).response { response, error in
                if let (metadata, url) = response {
                    if let image = self.drawPDFFromUrl(url : url){
                        self.listener.onEntryDetailsReceived(metaData : metadata, image : image)
                    }
                }
                else {
                    print("Error downloading file from Dropbox: \(error!)")
                }
            }
        }
    }
    func download(name : String , path : String) {
        if let client = DropboxClientsManager.authorizedClient {
            let destination : (URL, HTTPURLResponse) -> URL = {
                temporaryURL, response in
                let fileManager = FileManager.default
                let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let pathComponent = name
                return directoryURL.appendingPathComponent(pathComponent)
            }
            
            client.files.download(path: path, rev: nil, overwrite: true, destination: destination).response(completionHandler: {
                response, error in
                if let (metadata, url) = response {
                    self.listener.onFileDownloaded(metadata : metadata, url : url)
                } else {
                    self.listener.onFileNotDownloaded(error : error!)
                }
            }).progress({
                progress in
                self.listener.onDownloadProgressReceived(progress : progress)
            })
        }

    }
    func delete(path : String) {
        if let client = DropboxClientsManager.authorizedClient {
            client.files.delete(path: path).response(completionHandler: {
                result , error in
                if result != nil {
                    self.listener.onEntryRemoved()
                }
                else {
                    self.listener.onEntryNotRemoved(error : (error?.description)!)
                }
            })
        }
    }
    
    func drawPDFFromUrl(url : URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height);
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0);
            
            ctx.cgContext.drawPDFPage(page);
        }
        
        return img
    }
}
