//
//  ItunesTrack.swift
//  ItunesTableViewSearch
//
//  Created by Tomer Buzaglo on 01/05/2016.
//  Copyright © 2016 Tomer Buzaglo. All rights reserved.
//

import UIKit

class ItunesTrack:CustomStringConvertible, Hashable {
    var name: String
    var artist: String
    var previewUrlPath: String
    
    lazy var previewFileName:String = {
        return self.previewUrl?.lastPathComponent ?? ""
    }()
    
    lazy var previewUrl:NSURL? = {
        return NSURL(string: self.previewUrlPath)
    }()
    
    

    init(name: String, artist: String, previewUrlPath: String) {
        self.name = name
        self.artist = artist
        self.previewUrlPath = previewUrlPath
    }
    
    var description:String{
        return "\(name) , \(artist ), \(previewUrl)"
    }
    
    var hashValue: Int { return previewUrlPath.hash}

}

func ==(lhs: ItunesTrack, rhs: ItunesTrack) -> Bool{
    return lhs.previewUrl == rhs.previewUrl
}