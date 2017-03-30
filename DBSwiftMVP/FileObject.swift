//
//  FileObject.swift
//  DBSwiftMVP
//
//  S.Jan on 28/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit
//Only for conceptual purposes (not used in the project)
class FileObject: NSObject {
    
    //An example to show how easy it can be to have a 'generic' file object.
    
    /**
     Have your conform properties
        */
    var filename: String!
    var filesize : String!
    var etc : NSObject!
    
    /**
     Add an extension to the object based on the type
     */
    var fileExtensions : NSDictionary!
    /**
     Example: you can add key-value pairs with the corresponding identifiers to the extensions
     Hint: use an enum?
     
     key : DROPBOXEXTENSION
     value : DROPBOXFILEOBJECTEXTENSION
     
     key : KNFB
     value : KNFBFILEOBJECTEXTENSION
     ....
    */

}
