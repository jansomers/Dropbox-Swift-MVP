

import UIKit

class DropboxEntryViewObject: NSObject {
    //MARK: - Properties
    
    var folder : Bool!
    var fileName : String!
    var pathExtension : String?
    var pathLower : String!
    var pathDisplay : String!
    var parentFolder : String!
    var objectImage: UIImage?
    var size : String?
    var lastUpdate : String?
    private let lowerCaseSupportedImageExtensions = ["jpg", "jpeg", "png", "tiff", "tif", "gif", "bmp"]
    private let lowerCaseSupportedPreviewableExtensions = ["doc", "docx", "docm", "ppt", "pps", "ppsx" , "ppsm", "pptx", "pptm", "xls", "xlsx" ,"xlsm", "rtf"]
    
    //MARK: - Init
    
    init(fileName: String!, pathLower: String!, pathDisplay: String!, parentFolder : String!) {
        let pathExtension : String = (fileName as NSString).pathExtension
        self.pathExtension = pathExtension.characters.count > 0 ?  pathExtension : ""
        self.folder = pathExtension.characters.count > 0 ? false : true
        self.fileName = fileName
        self.pathLower = pathLower
        self.pathDisplay = pathDisplay
        
    }
    //MARK: - Setters
    func setSize(size : Int) {
        self.size = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }
    func setLastUpdate(date : Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        self.lastUpdate = dateFormatter.string(from: date)
    }
    
    //MARK: - Helpers Methods
    
    func isImage() -> Bool {
        return lowerCaseSupportedImageExtensions.contains((self.pathExtension?.lowercased())!)
    }
    
    func isPreviewable() -> Bool {
        return lowerCaseSupportedPreviewableExtensions.contains((self.pathExtension?.lowercased())!)
    }
    
    func isPDF() -> Bool {
        return self.pathExtension?.lowercased() == "pdf"
    }
    
    func getTypeImage() -> UIImage {
        return (self.folder! ? UIImage(named: "folder") : UIImage(named: self.pathExtension!) != nil ? UIImage(named: self.pathExtension!) : UIImage(named: "doc"))!
    }
}
