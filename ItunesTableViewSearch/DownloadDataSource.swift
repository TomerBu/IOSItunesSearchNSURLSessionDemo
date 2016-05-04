//
//  DownloadDataSource.swift
//  ItunesTableViewSearch
//
//  Created by Tomer Buzaglo on 03/05/2016.
//  Copyright © 2016 Tomer Buzaglo. All rights reserved.
//

import UIKit

class DownloadDataSource:NSObject{
    lazy var downloadsSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    func download(url:NSURL, delegate:((Download)->())?) {
        print("Downloading: \(url)")
        
        let task = downloadsSession.downloadTaskWithURL(url)
        let download = Download(url: url, task:task, delegate:delegate)
        activeDownloads[url] = download
        task.resume()
    }
    
    var activeDownloads = [NSURL : Download]()
    
    func pause(url:NSURL){
        if let task = activeDownloads[url]{
            task.pause()
        }
    }
    
    func resume(url:NSURL){
        if let task = activeDownloads[url]{
            task.resume()
        }
    }
    
    func cancel(url:NSURL){
        if let task = activeDownloads[url]{
            task.cancel()
            activeDownloads[url] = nil
        }
    }
}

//lots of delegate methods-> NSURLSessionDownloadDelegate: NSURLSessionTaskDelegate : NSURLSessionDelegate
extension DownloadDataSource : NSURLSessionDownloadDelegate{
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        //
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){
        guard let originalUrl =  downloadTask.originalRequest?.URL, let fileName = originalUrl.lastPathComponent else {return}
        
        
        FileIO.copyFile(from: location, toDocumentsDirectoryWithFileName: fileName)
        activeDownloads[originalUrl] = nil
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let originalUrl =  downloadTask.originalRequest?.URL else {return}
        
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        let totalSize = NSByteCountFormatter.stringFromByteCount(totalBytesExpectedToWrite, countStyle: NSByteCountFormatterCountStyle.Binary)
        
        let downloadData = activeDownloads[originalUrl]
        downloadData?.progress = progress
        downloadData?.textProgress = String(format: "%.1f%% of %@",  progress * 100, totalSize)
        
        dispatch_async(dispatch_get_main_queue(), {
            //Report the progress and text progress to delegate
            downloadData?.delegate?(downloadData!)
        })
    }
}