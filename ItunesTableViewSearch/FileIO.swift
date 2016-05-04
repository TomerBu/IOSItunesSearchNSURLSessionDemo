//
//  FileIO.swift
//  ItunesTableViewSearch
//
//  Created by Tomer Buzaglo on 04/05/2016.
//  Copyright © 2016 Tomer Buzaglo. All rights reserved.
//

import UIKit

class FileIO{
    
    static func saveJPEG(image: UIImage, path: String ) -> Bool{
        //UIImage To NSData? as .jpg
        let jpegData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        
        //data.writeToFile
        return jpegData?.writeToFile(path, atomically: true) ?? false
    }
    
    static func saveAsPng(image:UIImage, path:String)->Bool{
        //UIImage To NSData? as .png
        let pngData = UIImagePNGRepresentation(image)
        //data.writeToFile
        return pngData?.writeToFile(path, atomically: true) ?? false
    }
    
    static func documentsURL() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    }
    
    static func filePathInDocumentsDirectory(filename: String) -> String? {
        return fileUrlInDocumentsDirectory(filename).path
    }
    
    static func fileUrlInDocumentsDirectory(filename: String) -> NSURL {
        return documentsURL().URLByAppendingPathComponent(filename)
    }
    
    static func fileUrlInDocumentsDirectoryWithTimeStamp(name:String, ext:String) -> NSURL? {
        //trim dots (.) from the extension to prevent usage confusion
        let ext = ext.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "."))
        
        //Use a String formatter to get the time in a desired String representation
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss_SSS"
        
        //get the current timeStamp String from the formatter
        let timeStamp = formatter.stringFromDate(NSDate())
        
        //build a url from the components(dir, filename + timeStamp + .ext)
        return fileUrlInDocumentsDirectory("\(name)_\(timeStamp).\(ext)")
    }
    
    
    static func copyFile(from:NSURL, to:NSURL){
        do {
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtURL(to)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
            
            try NSFileManager.defaultManager().copyItemAtURL(from, toURL: to)
        }
        catch let error as NSError{
            print(error.description)
        }
    }
    
    static func copyFile(from from:NSURL, toDocumentsDirectoryWithFileName name:String){
        let to = fileUrlInDocumentsDirectory(name)
        copyFile(from, to: to)
    }
    
    static func fileExistsInDocumentsDirectory(name:String)->Bool{
        return NSFileManager.defaultManager().fileExistsAtPath(filePathInDocumentsDirectory(name) ?? "")
    }
    
    static func fileExistsInURL(url:NSURL)->Bool{
        if let path = url.path{
            return NSFileManager.defaultManager().fileExistsAtPath(path)
        }
        return false
    }
    
    static func fileNameFromUrl(url:NSURL)->String?{
        return url.lastPathComponent
    }
}
