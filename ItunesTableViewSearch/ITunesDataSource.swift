//
//  ITunesDataSource.swift
//  ItunesTableViewSearch
//
//  Created by Tomer Buzaglo on 03/05/2016.
//  Copyright © 2016 Tomer Buzaglo. All rights reserved.
//

import UIKit

class ITunesDataSource{
    
    //MARK: class fields
    let session:NSURLSession
    var task:NSURLSessionDataTask?
    var delegate:(([ItunesTrack])->())?
    
    var tunes = [ItunesTrack](){
        didSet{
            dispatch_async(dispatch_get_main_queue()) { 
                self.delegate?(self.tunes)
            }
        }
    }

    //MARK: inits
    init(){
        //session configuration:
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.allowsCellularAccess = true
        config.HTTPAdditionalHeaders = ["1":"", "2":""]
        session = NSURLSession(configuration: config)
    }
    
    //MARK: public API
    func query(query:String, delegate:([ItunesTrack])->()) {
        task?.cancel()
        self.delegate = delegate
        //encode the query string by escaping characters:
        let query = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(query ?? "")")
        
        task = session.dataTaskWithURL(url!) { (data, response, error) in
            guard let response = response as? NSHTTPURLResponse else{return}
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if response.statusCode == 200{
                if let data = data{
                    self.parseJson(data)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            }
        }
        task?.resume()
    }
    
    //MARK: private helper methods
    //parse response JSON NSData into an array of ITunesTrack.
    private func parseJson(data: NSData){
        self.tunes.removeAll()
        var tunes = [ItunesTrack]()
        do{
            let json =  try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            guard let results = json["results"] as? Array<NSDictionary> else {return}
            for tuneJson in results{
                let artistName = tuneJson["artistName"] as! String
                let trackName = tuneJson["trackName"] as! String
                let previewUrl = tuneJson["previewUrl"] as! String
                let tune = ItunesTrack(name: trackName, artist: artistName, previewUrlPath: previewUrl)
                tunes.append(tune)
            }
            self.tunes = tunes
        }
        catch let e as NSError{
            print(e.description)
        }
    }
}
