//
//  DropboxEntriesInteractor.swift
//  DBSwiftMVP
//
//  S.Jan on 27/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxEntriesInteractor {
    //MARK: - Properties
    
    weak var listener : DropboxEntriesListener?
    
    //MARK: - Init
    init(listener : DropboxEntriesListener) {
        self.listener = listener
    }
    
    //MARK: - Api methods
    func getDropboxEntries(path: String){
        var i = 0
        if let client = DropboxClientsManager.authorizedClient {
            client.files.listFolder(path: path).response(completionHandler: {
                result , error in
                if result != nil {
                    self.listener?.onGetEntriesSuccess(entries: result?.entries)
                } else {
                    //Request Error
                    self.listener?.onGetEntriesError(reason: error.debugDescription)
                    i += 1
                    if i > 3 {
                    DropboxClientsManager.authorizedClient = nil
                    }
                }
            })
        } else {
            //Client error
        }
    }
}
