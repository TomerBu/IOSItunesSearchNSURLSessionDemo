//
//  Download.swift
//  ItunesTableViewSearch
//
//  Created by Tomer Buzaglo on 03/05/2016.
//  Copyright © 2016 Tomer Buzaglo. All rights reserved.
//

import UIKit

class Download: NSObject {
    
    var url: NSURL
    var task: NSURLSessionDownloadTask?
    var delegate : ((Download)->())?
    
    var isDownloading = true //if we init a download - we are probably downloading
    var progress: Float = 0.0
    var textProgress:String = ""
    
    var resumeData: NSData?
    
    init(url: NSURL, task:NSURLSessionDownloadTask?, delegate: ((Download)->())?) {
        self.url = url
        self.task = task
        self.delegate = delegate
    }
    
    func resume(){
        self.task?.resume()
    }
    
    func pause(){
        self.task?.suspend()
    }
    
    func cancel(){
        self.task?.cancel()
        isDownloading = false
    }
}